//
//  AQueryItemProvider.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

protocol AQueryItemProvider {
    
    func queryItems(jsonEncoder: JSONEncoder) throws -> [URLQueryItem]?
    
}


extension Dictionary: AQueryItemProvider where Key == String {
    
    func queryItems(jsonEncoder: JSONEncoder = .init()) -> [URLQueryItem]? {
        reduce(into: [URLQueryItem]()) { acc, keyValue in
            acc?.append(URLQueryItem(name: keyValue.key, value: "\(keyValue.value)"))
        }
    }
    
}



extension AQueryItemProvider where Self: Encodable {
    
    func queryItems(jsonEncoder: JSONEncoder) throws -> [URLQueryItem]? {
        let dict = try toDictionary(withEncoder: jsonEncoder)
        return dict?.queryItems(jsonEncoder: jsonEncoder)
    }
    
}
