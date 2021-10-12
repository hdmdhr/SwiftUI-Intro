//
//  HttpClient.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation
import Combine

final class HttpClient {
    internal init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    
    private let urlSession: URLSession
    
    func networkRequestPublisher<Response: Decodable>(url: URL,
                                                      method: HttpMethod,
                                                      jsonDecoder: JSONDecoder = .init()) -> AnyPublisher<Response, Error>
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.httpMethod
        
        // body
        if case let .mutable(bodyDataProvider, _) = method {
            urlRequest.httpBody = try? bodyDataProvider.bodyData()
        }
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
}
