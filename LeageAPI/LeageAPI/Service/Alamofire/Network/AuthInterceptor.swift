//
//  AuthInterceptor.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    // 1 재시도하는 횟수를 정해주거나, 재시도할때 딜레이를 설정
    let retryList = 0
    let retryDelay: TimeInterval = 0
    
    // 2 네트워크를 통해 요청되기 전에 실행된다. 여기서 Authorization 헤더를 추가
    func adpat(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = TokenStorage.shared.accessToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }
    
    // 3 요청에 이러가 발생할때만 실행, completion의 RetryResult로 재시도를 할 것인지 설정해줘야 한다.
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
    }
    
}
