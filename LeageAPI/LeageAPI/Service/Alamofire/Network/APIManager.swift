//
//  APIManager.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/04.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        configuration.timeoutIntervalForRequest = 30
        let apiLogger = APIEventLogger()
        let interceptor = AuthInterceptor()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [apiLogger])
    }()
}
