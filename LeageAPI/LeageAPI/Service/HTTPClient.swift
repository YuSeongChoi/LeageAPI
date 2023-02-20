//
//  HTTPClient.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import UIKit
import Alamofire
import os

extension Session {
    static var newInstance: Session {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30
        
//        let eventLogger = APIEventLogger()
        let eventLogger = DataMonitor()
        let session = Session(configuration: config, cachedResponseHandler: ResponseCacher.cache, eventMonitors: [eventLogger])
        
        return session
    }
    
    static let HTTPclient: Session = .newInstance
}

struct APIEventLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "NetworkLogger")
    
    // request가 끝났을 때 호출, 파라미터 request에 접근하여 header, body, method 등을 확인할 수 있다.
    func requestDidFinish(_ request: Request) {
        print("----------------------------------------------------\n\n" + "              🛰 NETWORK Reqeust LOG\n" + "\n----------------------------------------------------")
                print("1️⃣ URL / Method / Header" + "\n" + "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
                      + "Method: " + (request.request?.httpMethod ?? "") + "\n"
                      + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
                print("----------------------------------------------------\n2️⃣ Body")

        if let body = request.request?.httpBody, !body.isEmpty {
            print("Body: \(String(decoding: body, as: UTF8.self))")
        } else { print("보낸 Body가 없습니다.")}
        print("----------------------------------------------------\n")
    }

//     response가 오면 호출, response의 결과에 따라 통신 결과를 요약해서 확인할 수 있다.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("              🛰 NETWORK Response LOG")
        print("\n----------------------------------------------------")

        switch response.result {
        case .success(_):
            print("3️⃣ 서버 연결 성공")
        case .failure(_):
            print("3️⃣ 서버 연결 실패")
            print("올바른 URL인지 확인해보세요.")
        }

        print("Result: " + "\(response.result)" + "\n" + "StatusCode: " + "\(response.response?.statusCode ?? 0)")

        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 400..<500:
                print("❗오류 발생 : RequestError\n" + "잘못된 요청입니다. request를 재작성 해주세요.")
            case 500:
                print("❗오류 발생 : ServerError\n" + "Server에 문제가 발생했습니다.")
            default:
                break
            }
        }

        print("----------------------------------------------------")
        print("4️⃣ Data 확인하기")
        if let response = response.data?.toPrettyPrintedString {
            print(response)
        } else {
            print("❗데이터가 없거나, Encoding에 실패했습니다.")
        }
        print("----------------------------------------------------")
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("URLSessionTask가 Fail 했습니다.")
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("URLRequest를 만들지 못했습니다.")
    }
    
    func requestDidCancel(_ request: Request) {
        print("request가 cancel 되었습니다.")
    }
    
}

struct DataMonitor: EventMonitor {
    
    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier.unsafelyUnwrapped,
        category: "Alamofire"
    )
    let queue: DispatchQueue = .global(qos: .background)
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let result: Result<Data?, AFError>
        if let error = response.error {
            result = .failure(error)
        } else {
            result = .success(response.data)
        }
        let dataResponse = DataResponse(request: response.request, response: response.response, data: response.data, metrics: response.metrics, serializationDuration: response.serializationDuration, result: result)
        dataRequestDidParseResponse(request, didParseResponse: dataResponse)
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        dataRequestDidParseResponse(request, didParseResponse: response)
    }
    
    private func dataRequestDidParseResponse(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        var debugDescription = response.debugDescription
        debugDescription = debugDescription.replacingOccurrences(of: "\n", with: "\n│ ")
            .replacingOccurrences(of: "(\\[Body]:)\\s*\n│", with: "[Body]:\n ", options: [.regularExpression])
        
        if let requestData = response.request?.httpBody,
           !requestData.isEmpty,
           debugDescription.contains("[Body]: \(requestData)"),
           let contentType = response.request?.value(forHTTPHeaderField: "Content-Type"),
           contentType.lowercased().contains("charset=utf-8") {
            let requestBody = String(decoding: requestData, as: UTF8.self)
            debugDescription = debugDescription.replacingOccurrences(of: "[Body]: \(requestData)", with: "[Body]:\n\t\t\(requestBody)")
        }
        
        logger.log(
            level: .debug,
            """
            ┌───────────────────────────────────────────────
            │ \(debugDescription)
            └───────────────────────────────────────────────
            """
        )
    }
    
}

