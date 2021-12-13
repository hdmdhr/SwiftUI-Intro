//
//  AQueryItemsProvider.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

protocol AQueryItemsProvider {
    
    var queryJsonEncoder: JSONEncoder? { get }
    
    func queryItems() throws -> [URLQueryItem]
    
}

extension AQueryItemsProvider {
    
    var queryJsonEncoder: JSONEncoder? { .init() }
    
}


extension Dictionary: AQueryItemsProvider where Key == String {
    
    func queryItems() -> [URLQueryItem] {
        reduce(into: [URLQueryItem]()) { acc, keyValue in
            acc.append(URLQueryItem(name: keyValue.key, value: "\(keyValue.value)"))
        }
    }
    
}



extension AQueryItemsProvider where Self: Encodable {
    
    func queryItems() throws -> [URLQueryItem] {
        guard let encoder = queryJsonEncoder else { return [] }
        
        let dict = try toDictionary(withEncoder: encoder)
        return dict?.queryItems() ?? []
    }
    
}
