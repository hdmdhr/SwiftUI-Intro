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
                                                      method: HttpRawMethod,
                                                      jsonDecoder: JSONDecoder = .init()) -> AnyPublisher<Response, Error>
    {
        urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
}
