//
//  Encodable+.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation


extension Encodable {
    
    func toData(withEncoder encoder: JSONEncoder = .init()) throws -> Data {
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        
        #if DEBUG
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Encoded: ", jsonString)
        }
        #endif
        
        return data
    }
    
    
    func toDictionary(withEncoder encoder: JSONEncoder = .init()) throws -> [String: Any]? {
        let data = try self.toData(withEncoder: encoder)
        return try JSONSerialization.jsonObject(with: data) as? [String : Any]
    }
    
    
}
