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
        var bodyString: String?
        if let data = request.request?.httpBody {
            bodyString = String(data: data, encoding: .utf8)
        }
        let message = """
        🔵🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽
        ⬆️ Request Started: \(request.description)
        ⚡️ Headers: \(request.request?.allHTTPHeaderFields?.description ?? "None")
        ⚡️ Body: \(bodyString ?? "None")
        🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼
        """
        print(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        var responseString: String?
        if let data = response.data {
            responseString = String(data: data, encoding: .ascii)
        }
        let message = """
        🔵🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽🔽
        ⬇️ Response Received: \(response.request?.description ?? "No request description")
        ⚡️ Headers: \(response.response?.allHeaderFields.description ?? "None")
        ⚡️ Server response time: \( response.metrics.map { "\($0.taskInterval.duration)s" } ?? "None")
        ⚡️ Server response: \( responseString ?? "No body")
        🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼🔼
        """
        print(message)
    }
}
