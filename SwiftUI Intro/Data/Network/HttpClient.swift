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
        var url = url
        
        // query
        if case .get(let queryItemsProvider) = method {
            do {
                let queryItems = try queryItemsProvider.queryItems(jsonEncoder: .init())
                url.appendQueryItems(queryItems)
            } catch {
                // must be EncodingError
                return Self.mapErrorToAnyPublisher(error: error)
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.httpMethod
        
        // body
        if case let .mutable(bodyDataProvider, _) = method {
            do {
                urlRequest.httpBody = try bodyDataProvider.bodyData()
            } catch {
                // must be EncodingError
                return Self.mapErrorToAnyPublisher(error: error)
            }
        }
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    
    
    private static func mapErrorToAnyPublisher<Response: Decodable>(error: Error) -> AnyPublisher<Response, Error> {
        Fail<Response, Error>(error: error)
            .eraseToAnyPublisher()
    }
    
}
