//
//  Storage.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation

enum Environment {
    case dev
    case stage
    case real
}

let environment: Environment = .dev

class TokenStorage {
    static let shared = TokenStorage()
    var accessToken: String?
    var refreshToken: String?
    
    init(accessToken: String? = nil, refreshToken: String? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
