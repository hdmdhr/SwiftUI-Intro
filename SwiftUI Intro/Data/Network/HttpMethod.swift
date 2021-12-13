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
    case get(queryItemsProvider: AQueryItemsProvider?)
    case mutable(method: HttpRawMethod, bodyDataProvider: ABodyDataProvider?)
    
    var httpRawMethod: HttpRawMethod {
        switch self {
        case .get:
            return HttpRawMethod.GET
        case let .mutable(method, _):
            return method
        }
    }
}
