//
//  APIEventLogger.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/04.
//

import Foundation
import Alamofire

class APIEventLogger2: EventMonitor {
    // 1. 모든 이벤트를 저장하는 DispatchQueue가 필요, 성능을 위해 메인큐가 아닌 별도 serial queue를 만듬
    let queue = DispatchQueue(label: "com.ys.LeageAPI")
    // 2. 요청이 끝났을 때 호출되는 이 메소드에선 요청 내용을 출력한다.
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
    // 3. 응답을 받았을 때 호출된다. result, statusCode, JSON Data를 JSONSerialization으로 예쁘게 출력해준다.
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
