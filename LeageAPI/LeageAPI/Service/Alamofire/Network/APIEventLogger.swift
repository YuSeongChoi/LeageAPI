//
//  APIEventLogger.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/04.
//

import Foundation
import Alamofire

class APIEventLogger2: EventMonitor {
    // 1
    let queue = DispatchQueue(label: "com.ys.LeageAPI")
    // 2
    func requestDidFinish(_ request: Request) {
        print("⭐️REQUEST LOG")
        print(request.description)
        
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        print("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        print("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }
    // 3
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("⭐️RESPONSE LOG")
        print(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}
