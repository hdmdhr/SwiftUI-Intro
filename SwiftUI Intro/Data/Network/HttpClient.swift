//
//  HttpClient.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation
import Combine

class HttpClient {
    
    internal init(urlSession: URLSession, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    func networkRequestPublisher<Response: Decodable>(url urlConvertible: UrlConvertible,
                                                      method: HttpMethod,
                                                      methodJsonDecoder: JSONDecoder? = nil) -> AnyPublisher<Response, NetworkError>
    {
        var url = urlConvertible.url
        
        // query
        if case .get(let queryItemsProvider) = method {
            do {
                let queryItems = try queryItemsProvider.queryItems(jsonEncoder: .init())
                url.appendQueryItems(queryItems)
            } catch {
                // must be EncodingError
                return Self.mapErrorToAnyPublisher(error: .invalidRequest(innerError: error))
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
                return Self.mapErrorToAnyPublisher(error: .invalidRequest(innerError: error))
            }
        }
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapError{ NetworkError.urlError($0) }
            .map(\.data)
            .tryMap{ data in
                do {
                    return try (methodJsonDecoder ?? self.jsonDecoder).decode(Response.self, from: data)
                } catch {
                    throw NetworkError.decodingError(optError: error as? DecodingError, data: data)
                }
            }
            .mapError{ ($0 as? NetworkError) ?? .unknown($0) }
            .eraseToAnyPublisher()
    }
    
    
    private static func mapErrorToAnyPublisher<Response: Decodable>(error: NetworkError) -> AnyPublisher<Response, NetworkError> {
        Fail(error: error).eraseToAnyPublisher()
    }
    
}
