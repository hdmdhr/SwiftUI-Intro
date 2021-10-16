//
//  ABodyDataProvider.swift
//  SwiftUI Introduction
//
//  Created by 胡洞明 on 2021-10-10.
//

import Foundation


protocol ABodyDataProvider {
    func bodyData() throws -> Data
}

//struct DataBodyDataProvider: ABodyDataProvider {
//    let data: Data
//
//    func bodyData() throws -> Data {
//        data
//    }
//}

struct EncodableBodyDataProvider: ABodyDataProvider {
    let body: Encodable
    var jsonEncoder: JSONEncoder = .init()
    
    func bodyData() throws -> Data {
        try body.toData(withEncoder: jsonEncoder)
    }
}

