//
//  APIs.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation

enum APIs {
    
    enum Places: String, HasBaseUrl, UrlConvertible {
        static let baseUrl: URL? = .init(string: Constants.placeApiBaseUrlString)
        
        case searchPlaces = "places"
    }
    
    
    enum Staging: HasBaseUrl, UrlConvertible {
        static let baseUrl: URL? = .init(string: Constants.stagingApiBaseUrlString)
        
        case verifyPhone
        
        var optionalUrl: URL? {
            switch self {
            case .verifyPhone: return Account.Phone.verify.url
            }
        }
            
    }
    
    
}


let sampleUrl: URL = APIs.Staging.Account.Phone.verify.url
