//
//  Constants.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/13.
//

import Foundation

enum Constants {
    
    enum HomeTabItem: String, Hashable {
        case Home
        case Champion
        case Setting
        
        var title: String {
            switch self {
            case .Home:
                return "홈"
            case .Champion:
                return "챔피언"
            case .Setting:
                return "설정"
            }
        }
    }
    
}
