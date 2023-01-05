//
//  APIRouter.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation
import Alamofire

class APIRouter: URLRequestConvertible {
    // 1 enum으로 APIType을 정의, APIType을 auth와 service로 나누고, 케이스에 따른 baseURL을 저장
    enum APIType {
        case auth
        case service
        
        var baseURL: String {
            switch self {
            case .auth:
                switch environment {
                case .dev: return "https://auth.dev"
                case .stage: return "https://auth.dev"
                case .real: return "https://auth.real"
                }
            case .service:
                return "https://httpbin.org"
            }
        }
    }
    
    var path: String
    var httpMethod: HTTPMethod
    var parameters: Data?
    var apiType: APIType
    
    init(path: String, httpMethod: HTTPMethod? = .get, parameters: Data? = nil, apiType: APIType = .service) {
        self.path = path
        self.httpMethod = httpMethod ?? .get
        self.parameters = parameters
        self.apiType = apiType
    }
    
    func asURLRequest() throws -> URLRequest {
        // 2. base URL + path / baseURL과 path를 연결해서 URLComponent를 생성하고 퍼센트 인코딩을 한다.
        let fullURL = apiType.baseURL + path
        let encodedURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var urlComponent = URLComponents(string: encodedURL)!
        
        // 3. get> query parameter 추가 / get 방식일때 파라미터를 query parameter로 추가해주기 위해, Data 타입인 파라미터를 Dictionary로 타입캐스팅을 한 후에 queryItem으로 추가
        if httpMethod == .get, let params = parameters {
            if let dictionary = try? JSONSerialization.jsonObject(with: params, options: []) as? [String:Any] {
                var queries = [URLQueryItem]()
                for (name, value) in dictionary {
                    let encodedValue = "\(value)".addingPercentEncodingForRFC3986()
                    let queryItem = URLQueryItem(name: name, value: encodedValue)
                    queries.append(queryItem)
                }
                urlComponent.percentEncodedQueryItems = queries
            }
        }
        
        // 4. request 생성 / 2~4 과정으로 baseURL과 path, query parameter를 연결해서 URL을 만들었다. 이 URL로 Request를 생성한다.
        var request = try URLRequest(url: urlComponent.url!, method: httpMethod)
        
        // 5. post> json parameter 추가 / post 방식이면 httpBody를 추가하고, header에 Content-Type을 application/json으로 설정한다.
        if httpMethod == .post, let params = parameters {
            request.httpBody = params
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
}
