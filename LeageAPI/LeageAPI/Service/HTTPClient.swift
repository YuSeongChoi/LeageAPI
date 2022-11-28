//
//  HTTPClient.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import UIKit
import Alamofire

extension Session {
    static var newInstance: Session {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30
        
        let eventLogger = APIEventLogger()
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
        if let body = request.request?.httpBody?.toPrettyPrintedString {
            print("Body: \(body)")
        } else { print("보낸 Body가 없습니다.")}
        print("----------------------------------------------------\n")
    }
    
    // response가 오면 호출, response의 결과에 따라 통신 결과를 요약해서 확인할 수 있다.
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

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
