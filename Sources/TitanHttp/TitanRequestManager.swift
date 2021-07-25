//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 24/7/21.
//

import Foundation
import Alamofire
import Combine
import AlamofireNetworkActivityLogger

public class TitanRequestManager {
    private let session: Session
    
    // TODO: Later init with config options
    public init() {
        let configuration = Session.default.sessionConfiguration
        // TODO setup config
        
        let alamofireSession = Session.init(configuration: configuration,
                                            startRequestsImmediately: true,
                                            interceptor: nil,
                                            serverTrustManager: nil,
                                            redirectHandler: nil,
                                            cachedResponseHandler: nil,
                                            eventMonitors: [TitanLogger()])
        
        session = alamofireSession
    }
    
    public func makeRequest() -> AnyPublisher<Data, AFError> {
        return session.request("https://www.google.com").publishData().value()
    }
}
