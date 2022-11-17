//
//  Todo.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation

struct Todo: Codable, Hashable {
    
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
}
