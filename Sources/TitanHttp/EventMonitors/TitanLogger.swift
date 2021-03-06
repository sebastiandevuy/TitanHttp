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
        π΅π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½
        β¬οΈ Request Started: \(request.description)
        β‘οΈ Headers: \(request.request?.allHTTPHeaderFields?.description ?? "None")
        β‘οΈ Body: \(bodyString ?? "None")
        πΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌ
        """
        print(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard !request.isCancelled else {
            let message = """
            π΅π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½
            β¬οΈ Request Cancelled: \(response.request?.description ?? "No request description")
            πΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌ
            """
            print(message)
            return
        }
        var responseString: String?
        if let data = response.data {
            responseString = String(data: data, encoding: .ascii)
        }
        let message = """
        π΅π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½
        β¬οΈ Response Received: \(response.request?.description ?? "No request description")
        β‘οΈ Headers: \(response.response?.allHeaderFields.description ?? "None")
        β‘οΈ Server response time: \( response.metrics.map { "\($0.taskInterval.duration)s" } ?? "None")
        β‘οΈ Server response: \( responseString ?? "No body")
        πΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌπΌ
        """
        print(message)
    }
}
