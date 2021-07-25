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
    private let interceptor = TitanSessionRequestInterceptor()
    
    // TODO: Later init with config options
    public init() {
        let configuration = Session.default.sessionConfiguration
        // TODO setup config
        
        let alamofireSession = Session.init(configuration: configuration,
                                            startRequestsImmediately: true,
                                            interceptor: interceptor,
                                            serverTrustManager: nil,
                                            redirectHandler: nil,
                                            cachedResponseHandler: nil,
                                            eventMonitors: [TitanLogger()])
        
        session = alamofireSession
    }
    
    // TODO. Map Errors to own so no one has to refer to AF
    public func makeRequest(_ request: TitanHttpRequest) -> AnyPublisher<Data, AFError> {
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
                
                return dataRequest.publishData().value()
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
                
                return dataRequest.publishData().value()
            }
        } else {
            return session.request(request.url, method: HTTPMethod(rawValue: request.method.rawValue), headers: nil).publishData().value()
        }
    }
}

