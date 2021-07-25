//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation

public struct TitanConfiguration {
    let sessionConfiguration: URLSessionConfiguration?
    let authHandler: TitanAuthHandlerProtocol?
    
    public init(sessionConfiguration: URLSessionConfiguration? = nil,
                authHandler: TitanAuthHandlerProtocol? = nil) {
        self.sessionConfiguration = sessionConfiguration
        self.authHandler = authHandler
    }
    
}
