//
//  SummonerInfo.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/12.
//

import Foundation

struct SummonerInfo: Codable, Hashable {
    
    var accountId: String = ""
    var id: String = ""
    var profileIconId: Int = 0
    var summonerLevel: Int = 0
    var revisionDate: Int64 = 0
    var puuid: String = ""
    var name: String = ""
    
}
