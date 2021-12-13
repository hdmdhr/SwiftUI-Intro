//
//  EndpointHttpClient.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-31.
//

import Foundation
import Combine

/// Subclass of `CombineHttpClient`, associated with a specific type of endpoint
class EndpointHttpClient<Endpoint: UrlConvertible>: CombineHttpClient {
    
    internal init(urlSession: URLSession, endpointType: Endpoint.Type, jsonDecoder: JSONDecoder = .init()) {
        
        super.init(urlSession: urlSession, jsonDecoder: jsonDecoder)
    }
    
    
    func networkRequestPublisher<Response: Decodable>(endpoint: Endpoint,
                                                      method: HttpMethod) -> AnyPublisher<Response, NetworkError>
    {
        super.networkRequestPublisher(url: endpoint.url, method: method)
    }
    
}
