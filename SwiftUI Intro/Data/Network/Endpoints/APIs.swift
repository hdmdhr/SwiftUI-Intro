//
//  APIs.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation

enum APIs {
    
    enum Places: String, HasBaseUrl {
        static let baseUrl: URL? = .init(string: Constants.placeApiBaseUrlString)
        
        case searchPlaces = "places"
    }
    
    
    enum Staging: HasBaseUrl {
        static let baseUrl: URL? = .init(string: Constants.stagingApiBaseUrlString)
        
    }
    
    
}


let url: URL = APIs.Staging.Account.Phone.verify.url
