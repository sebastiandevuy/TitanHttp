//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 24/7/21.
//

import Foundation
import Alamofire
import Combine

public class TitanRequestManager {
    private let session: Session
    private let interceptor: TitanSessionRequestInterceptor?
    
    // TODO: Later init with config options
    public init(config: TitanConfiguration) {
        let sessionConfiguration = config.sessionConfiguration ?? Session.default.sessionConfiguration
        let interceptor = TitanSessionRequestInterceptor(authHandler: config.authHandler)
        self.interceptor = interceptor
        
        let alamofireSession = Session.init(configuration: sessionConfiguration,
                                            startRequestsImmediately: true,
                                            interceptor: interceptor,
                                            serverTrustManager: nil,
                                            redirectHandler: nil,
                                            cachedResponseHandler: nil,
                                            eventMonitors: [TitanLogger()])
        
        session = alamofireSession
    }
    
    // TODO. Map Errors to own so no one has to refer to AF
    public func makeRequest(_ request: TitanHttpRequest) -> AnyPublisher<Data, TitanError> {
        if let payload = request.payload {
            switch payload {
            case .dictionary(let value,
                             let encoding):
                let dataRequest = session.request(request.url,
                                        method: HTTPMethod(rawValue: request.method.rawValue),
                                        parameters: value,
                                        encoding: encoding == .json
                                         ? JSONEncoding.default
                                         : URLEncoding.default,
                                        headers: nil)
                
                let cacher = ResponseCacher(behavior: request.ignoreCache ? .doNotCache : .cache)
                dataRequest.cacheResponse(using: cacher)
                
                return dataRequest
                    .validate()
                    .publishData()
                    .value()
                    .mapError { error in
                    return TitanError.afError(description: error.localizedDescription)
                }.eraseToAnyPublisher()
            case .encodable(let value, let encoding):
                let dataRequest = session.request(request.url,
                                              method: HTTPMethod(rawValue: request.method.rawValue),
                                              parameters: value.dictionary,
                                              encoding: encoding == .json
                                               ? JSONEncoding.default
                                               : URLEncoding.default,
                                              headers: nil)
                
                let cacher = ResponseCacher(behavior: request.ignoreCache ? .doNotCache : .cache)
                dataRequest.cacheResponse(using: cacher)
                
                return dataRequest
                    .validate()
                    .publishData()
                    .value().mapError { error in
                    return TitanError.afError(description: error.localizedDescription)
                }.eraseToAnyPublisher()
            }
        } else {
            return session.request(request.url, method: HTTPMethod(rawValue: request.method.rawValue), headers: nil)
                .validate()
                .publishData()
                .value()
                .mapError { error in
                return TitanError.afError(description: error.localizedDescription)
            }.eraseToAnyPublisher()
        }
    }
}

