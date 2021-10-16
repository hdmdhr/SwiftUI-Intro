//
//  NetworkError.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-16.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    
    /// Inner error is very likely to be an `EncodingError`
    case invalidRequest(innerError: Error)
    case decodingError(DecodingError?)
    case urlError(URLError)
    
    var description: String {
        switch self {
        case .invalidRequest(let innerError):
            if let encodingError = innerError as? EncodingError {
                print(encodingError)
            }
            
            return "Invalid request"
            
        case .decodingError(let optDecodingError):
            if let decodingError = optDecodingError {
                print(decodingError)
            }
            
            return "I want to extract `message` from returned payload"
            
        case .urlError(let urlError):
            let debugMessage = ([urlError.errorCode, urlError.failureURLString ?? "", urlError.code]).compactMap{ "\($0)" }.joined(separator: ", ")
            print(debugMessage)
            
            return urlError.localizedDescription
        }
    }
    
}
