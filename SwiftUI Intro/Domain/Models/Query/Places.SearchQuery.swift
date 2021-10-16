//
//  Places.SearchQuery.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

enum Places {
    
    struct SearchQuery: Encodable, AQueryItemsProvider {
        var type: PlaceType?
        var keyword: String?
    }
    
    enum PlaceType: String, Codable {
        case restaurant,
             gym,
             theatre,
             museum,
             gallery,
             casino,
             park
    }
    
}

