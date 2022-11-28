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
    
    struct TodoRequest: DataRequestFormProtocol, Encodable {
        var path: String { "/todos" }
        var method: HTTPMethod { .get }
        var validation: DataRequest.Validation? { nil }
    }
    
    struct UserDataRequest: DataRequestFormProtocol, Encodable {
        var path: String { "/lol/summoner/v4/summoners/by-name/\(summonerName)" }
        var method: HTTPMethod { .get }
        var validation: DataRequest.Validation? { nil }
        var summonerName: String
        func asURLRequest() throws -> URLRequest {
            return try encoder.encode(["api_key": API.key], into: baseRequest)
        }
    }
    
}
