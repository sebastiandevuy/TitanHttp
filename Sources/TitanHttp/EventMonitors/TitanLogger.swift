//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation
import Alamofire

final class TitanLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let message = """
        ⬆️ Request Started: \(request.description)
        """
        NSLog(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let message = """
        ⬇️ Response Received: \(response.debugDescription)
        """
        NSLog(message)
    }
}
