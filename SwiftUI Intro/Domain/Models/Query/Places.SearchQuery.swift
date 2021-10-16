//
//  Places.SearchQuery.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

enum Places {
    
    struct SearchQuery: Encodable, AQueryItemsProvider {
        var type: TypeEnum?
        var keyword: String?
        var page: Int = 0
        var perPage: Int = 10
    }
    
    enum TypeEnum: String, Codable {
        case restaurant,
             gym,
             theatre,
             museum,
             gallery,
             casino,
             park
    }
    
}

