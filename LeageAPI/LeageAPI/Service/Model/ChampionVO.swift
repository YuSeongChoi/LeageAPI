//
//  ChampionVO.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/02/20.
//

import Foundation

// MARK: - ChampionVO
struct ChampionVO: Codable {
    var type: TypeEnum = .champion
    var format: String = ""
    var version: Version = .the1331
    var data: [String: ChampionData] = .init()
}

// MARK: - Datum
struct ChampionData: Codable {
    let version: Version
    let id, key, name, title: String
    let blurb: String
    let info: Info
    let image: ChampionImage
    let tags: [Tag]
    let partype: String
    let stats: [String: Double]
}

// MARK: - Image
struct ChampionImage: Codable {
    let full: String
    let sprite: Sprite
    let group: TypeEnum
    let x, y, w, h: Int
}

enum TypeEnum: String, Codable {
    case champion = "champion"
}

enum Sprite: String, Codable {
    case champion0PNG = "champion0.png"
    case champion1PNG = "champion1.png"
    case champion2PNG = "champion2.png"
    case champion3PNG = "champion3.png"
    case champion4PNG = "champion4.png"
    case champion5PNG = "champion5.png"
}

// MARK: - Info
struct Info: Codable {
    let attack, defense, magic, difficulty: Int
}

enum Tag: String, Codable {
    case assassin = "Assassin"
    case fighter = "Fighter"
    case mage = "Mage"
    case marksman = "Marksman"
    case support = "Support"
    case tank = "Tank"
}

enum Version: String, Codable {
    case the1331 = "13.3.1"
}
