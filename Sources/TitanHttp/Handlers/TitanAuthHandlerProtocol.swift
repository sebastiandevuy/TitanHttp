//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation

public protocol TitanAuthHandlerProtocol {
    
    /// Invoked in each request to adapt the request adding additional headers for authentication
    /// - Parameter request: unmodified request to be sent
    func getAuthenticationHeadersIfNeeded(forRequest request: URLRequest) -> [String: String]?
    
    /// Provides the request that failed with 403 to obtain credentials and have them available for next retry
    /// - Parameters:
    ///   - request: original request
    ///   - completion: signals the library of the authentication credentials update result in order to retry or not
    func updateAuthentication(forRequest request: URLRequest, completion: @escaping (AuthenticationUpdateResult) -> Void)
}

public enum AuthenticationUpdateResult {
    case success
    case failure
    case notRelevant
}
