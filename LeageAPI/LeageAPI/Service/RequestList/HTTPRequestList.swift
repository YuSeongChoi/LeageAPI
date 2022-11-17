//
//  HTTPRequestList.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import Alamofire

enum HTTPRequestList {}

extension HTTPRequestList {
    
    struct TodoRequest: DataRequestFormProtocol {
        var path: String { "/todos" }
        var method: HTTPMethod { .get }
        var validation: DataRequest.Validation? { nil }
    }
    
}
