//
//  AsyncHttpClient.swift
//  SwiftUI Intro
//
//  Created by Daniel Hu on 2021-12-13.
//

import Foundation

class AsyncHttpClient {
    
    
    internal init(urlSession: URLSession, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    func request<Response: Decodable>(url urlConvertible: UrlConvertible, method: HttpMethod) async throws -> Response {
        var url = urlConvertible.url
        
        // query (optional: only GET, and has a query items provider)
        if case .get(let queryItemsProvider) = method, let provider = queryItemsProvider {
            do {
                let queryItems = try provider.queryItems()
                url.appendQueryItems(queryItems)
            } catch {
                // must be EncodingError
                throw NetworkError.invalidRequest(innerError: error)
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.httpRawMethod.rawValue
        
        // body (optional: only when method is not GET, and has a body data provider)
        if case let .mutable(_, bodyDataProvider) = method, let provider = bodyDataProvider {
            do {
                urlRequest.httpBody = try provider.bodyData()
            } catch {
                // must be EncodingError
                throw NetworkError.invalidRequest(innerError: error)
            }
        }
        
        var data: Data = .init()
        
        do {
            let (d, urlResponse) = try await urlSession.data(for: urlRequest, delegate: nil)
            data = d
            
            let response = try jsonDecoder.decode(Response.self, from: data)
            
            #if DEBUG
            let debugMessage = [
                urlRequest.httpMethod,
                urlRequest.url?.relativeString,
                (urlResponse as? HTTPURLResponse)?.statusCode.toString,
                data.prettyJsonString
            ]
                .compactMap { $0 }
                .joined(separator: "\n")
            
            print(debugMessage)
            #endif
            
            return response
            
        } catch let urlError as URLError {
            throw NetworkError.urlError(urlError)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError, data: data)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    
}
