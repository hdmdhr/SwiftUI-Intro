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
        
        
        private static let randomImageUrl = URL(string: "https://picsum.photos/id/1079/300/200")!
        
        static func randomPlace() -> Place {
            let id = String(Int.random(in: 1...100))
            let place = Place(id: id, name: "Place \(id)", address: "some place", type: .casino, imageUrl: randomImageUrl)
            
            return place
        }
        
        static func randomPlaces(count: Int) -> [Place] {
            (1...count).map { id in
                    .init(id: String(id), name: "Place \(id)", address: "somewhere", type: .casino, imageUrl: Self.randomImageUrl)
            }
        }
    }
    
}
