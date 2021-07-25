//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation

public struct TitanHttpRequest {
    let url: String
    let method: HttpMethod
    let payload: Payload?
    let headers: [String: String]?
    let ignoreCache: Bool
    
    public init(url: String,
                method: HttpMethod,
                payload: Payload? = nil,
                headers: [String: String]? = nil,
                ignoreCache: Bool = true) {
        self.url = url
        self.method = method
        self.payload = payload
        self.headers = headers
        self.ignoreCache = ignoreCache
    }
}

public enum HttpMethod: String, Equatable {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

public enum PayloadEncoding {
    case url
    case json
}

public enum Payload {
    case dictionary(value: [String: Any],
                    encoding: PayloadEncoding)
    case encodable(value: Encodable,
                   encoding: PayloadEncoding)
}
