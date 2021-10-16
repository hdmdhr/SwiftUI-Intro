//
//  Envelop.swift
//  SwiftUI Introduction
//
//  Created by 胡洞明 on 2021-10-10.
//

import Foundation

struct Envelop<D: Decodable>: Decodable {
    let data: D
    let code: String
    let message, exceptionName, stackTrace: String?
}
