//
//  AuthInterceptor.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    // 1
    let retryList = 0
    let retryDelay: TimeInterval = 0
    
    // 2
    func adpat(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    // 3
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
    }
    
}
