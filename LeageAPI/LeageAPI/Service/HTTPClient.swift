//
//  HTTPClient.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import UIKit
import Alamofire

extension Session {
    static var newInstance: Session {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30
        
        let session = Session(configuration: config, cachedResponseHandler: ResponseCacher.cache)
        return session
    }
    
    static let HTTPclient: Session = .newInstance
}
