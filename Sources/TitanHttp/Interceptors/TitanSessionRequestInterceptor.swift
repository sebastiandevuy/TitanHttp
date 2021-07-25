//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation
import Alamofire

class TitanSessionRequestInterceptor: RequestInterceptor {
    private let authHandler: TitanAuthHandlerProtocol?
    private let lock = NSLock()
    
    init(authHandler: TitanAuthHandlerProtocol? = nil) {
        self.authHandler = authHandler
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let authHandler = authHandler,
              let authHeaders = authHandler.getAuthenticationHeadersIfNeeded(forRequest: urlRequest) else {
            completion(.success(urlRequest))
            return
        }
        var request = urlRequest
        authHeaders.forEach({request.headers.add(name: $0.key, value: $0.value)})
        completion(.success(request))
        
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let originalRequest = request.request,
            let statusCode = request.response?.statusCode,
              let authHandler = authHandler else {
            completion(.doNotRetry)
            return
        }
        
        switch statusCode {
        case 403:
            //Do auth again and avoid retry beyond once for it
            guard request.retryCount < 1 else {
                completion(.doNotRetry)
                return
            }
            lock.lock()
            authHandler.updateAuthentication(forRequest: originalRequest) { [weak self] success in
                success ? completion(.retry) : completion(.doNotRetry)
                self?.lock.unlock()
            }
        default:
            completion(.doNotRetry)
        }
        
    }
}
