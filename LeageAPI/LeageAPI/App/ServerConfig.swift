//
//  ServerConfig.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import NetworkExtension

let ServerConstant: ServerConfiguration = {
    let config: ServerConfiguration
//    config = .Test
    config = .League
    return config
}()

struct ServerConfiguration: Hashable, Sendable {
    var baseURL: String
    var ddragonURL: String
}

extension ServerConfiguration {
    static var Test: Self {
        .init(
            baseURL: "https://jsonplaceholder.typicode.com",
            ddragonURL: "https://ddragon.leagueoflegends.com/cdn/12.23.1"
        )
    }
    
    static var League: Self {
        .init(
            baseURL: "https://kr.api.riotgames.com",
            ddragonURL: "https://ddragon.leagueoflegends.com/cdn/12.23.1"
        )
    }
}
