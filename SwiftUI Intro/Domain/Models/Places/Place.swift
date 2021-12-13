//
//  Place.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

typealias Place = Places.Place

extension Places {
    
    struct Place: Decodable {
        let id, name, address: String
        let type: TypeEnum
        let imageUrl: URL
    }
    
}
