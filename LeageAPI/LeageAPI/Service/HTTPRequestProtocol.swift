//
//  HTTPRequestProtocol.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import Alamofire

class API {

    static let key = "YOUR_KEY"
    
}

protocol RequestFormProtocol: URLRequestConvertible {
    
    var base: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
}

extension RequestFormProtocol {
    
    var base: String { ServerConstant.baseURL }
    
    var baseRequest: URLRequest {
        get throws {
            let url = try base.asURL().appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.method = method
            return request
        }
    }
    
}

extension RequestFormProtocol {
    
    func asURLRequest() throws -> URLRequest {
        try baseRequest
    }
    
}

protocol DataRequestFormProtocol: RequestFormProtocol, Sendable {
    
    var encoder: ParameterEncoder { get }
    var validation: DataRequest.Validation? { get }
    func buildDataRequest(_ interceptor: RequestInterceptor?) -> DataRequest
    
}

extension DataRequestFormProtocol {
    
    var encoder: ParameterEncoder {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "yyyyMMdd"
        let URLEncoder = URLEncodedFormEncoder(arrayEncoding: .noBrackets, dateEncoding: .formatted(formatter))
        return URLEncodedFormParameterEncoder(encoder: URLEncoder)
    }
    
    func buildDataRequest(_ interceptor: RequestInterceptor? = nil) -> DataRequest {
        let request = Session.HTTPclient.request(self, interceptor: interceptor).validate()
        if let validator = validation {
            return request.validate(validator)
        } else {
            return request
        }
    }
    
}

extension DataRequestFormProtocol where Self: Encodable {
    
    func asURLRequest() throws -> URLRequest {
        try encoder.encode(self, into: baseRequest)
    }
    
}


