//
//  Staging.Account.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation

extension APIs.Staging {
    
    enum Account: HasBaseUrl {
        static let baseUrl: URL? = APIs.Staging.baseUrl?.appendingPathComponent(path)
        
        enum Phone: String, HasBaseUrl, UrlConvertible {
            static let baseUrl: URL? = Account.baseUrl?.appendingPathComponent(path)
            
            case verify
        }
    }
    
    
}
