//
//  HttpMethod.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation


enum HttpRawMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}


enum HttpMethod {
    case get
    case mutable(bodyDataProvider: ABodyDataProvider, method: HttpRawMethod)
    
    var httpMethod: String {
        switch self {
        case .get:
            return HttpRawMethod.GET.rawValue
        case let .mutable(_, method):
            return method.rawValue
        }
    }
}
