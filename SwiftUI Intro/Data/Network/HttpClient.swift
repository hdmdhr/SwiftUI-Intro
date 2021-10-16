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
                                                      jsonDecoder: JSONDecoder = .init()) -> AnyPublisher<Response, NetworkError>
    {
        var url = url
        
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
            .decode(type: Response.self, decoder: jsonDecoder)
            .mapError{ NetworkError.decodingError($0 as? DecodingError) }
            .eraseToAnyPublisher()
    }
    
    
    private static func mapErrorToAnyPublisher<Response: Decodable>(error: NetworkError) -> AnyPublisher<Response, NetworkError> {
        Fail(error: error).eraseToAnyPublisher()
    }
    
}
