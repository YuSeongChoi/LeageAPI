//
//  HttpbinResponse.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation

/// 응답값
struct HttpbinResponse: Decodable {
    var url: String?
    var json: UserInfo?
}
