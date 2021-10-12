//
//  Encodable+.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation


extension Encodable {
    
    func toData(withEncoder encoder: JSONEncoder = .init()) throws -> Data {
        let data = try encoder.encode(self)
        
        #if DEBUG
        if let jsonObj = try? JSONSerialization.jsonObject(with: data),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8)
        {
            print("Encoded: ", jsonString)
        }
        #endif
        
        return data
    }
    
}
