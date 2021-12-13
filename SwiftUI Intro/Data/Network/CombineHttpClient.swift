//
//  CombineHttpClient.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import Foundation
import Combine

class CombineHttpClient {
    
    internal init(urlSession: URLSession, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    func networkRequestPublisher<Response: Decodable>(url urlConvertible: UrlConvertible,
                                                      method: HttpMethod) -> AnyPublisher<Response, NetworkError>
    {
        var url = urlConvertible.url
        
        // query
        if case .get(let queryItemsProvider) = method, let provider = queryItemsProvider {
            do {
                let queryItems = try provider.queryItems()
                url.appendQueryItems(queryItems)
            } catch {
                // must be EncodingError
                return Self.mapErrorToAnyPublisher(error: .invalidRequest(innerError: error))
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.httpRawMethod.rawValue
        
        // body
        if case let .mutable(_, bodyDataProvider) = method, let provider = bodyDataProvider {
            do {
                urlRequest.httpBody = try provider.bodyData()
            } catch {
                // must be EncodingError
                return Self.mapErrorToAnyPublisher(error: .invalidRequest(innerError: error))
            }
        }
        
        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapError{ NetworkError.urlError($0) }
            .map(\.data)
            .tryMap{ [self] data in
                do {
                    return try jsonDecoder.decode(Response.self, from: data)
                } catch let decodingError as DecodingError {
                    throw NetworkError.decodingError(decodingError, data: data)
                } catch let urlError as URLError {
                    throw NetworkError.urlError(urlError)
                } catch {
                    throw NetworkError.unknown(error)
                }
            }
            .mapError{ ($0 as? NetworkError) ?? .unknown($0) }
            .eraseToAnyPublisher()
    }
    
    
    private static func mapErrorToAnyPublisher<Response: Decodable>(error: NetworkError) -> AnyPublisher<Response, NetworkError> {
        Fail(error: error).eraseToAnyPublisher()
    }
    
}
