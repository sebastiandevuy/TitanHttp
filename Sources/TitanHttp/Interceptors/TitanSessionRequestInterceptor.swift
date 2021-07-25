//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation
import Alamofire

class TitanSessionRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
