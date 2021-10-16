//
//  NetworkError.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

enum NetworkError: Error {
    
    /// Inner error is very likely to be an `EncodingError`
    case invalidRequest(innerError: Error)
    case decodingError(DecodingError?)
    case urlError(URLError)
    
}
