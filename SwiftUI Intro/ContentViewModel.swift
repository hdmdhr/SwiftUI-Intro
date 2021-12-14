//
//  ContentViewModel.swift
//  SwiftUI Intro
//
//  Created by Daniel Hu on 2021-12-13.
//

import Foundation
import Combine

extension ContentView {
    
    class FakeViewModel: ViewModel {
        
        private static let randomImageUrl = URL(string: "https://picsum.photos/id/1079/300/200")!
        
        static func randomPlace() -> Place {
            let id = String(Int.random(in: 1...100))
            let place = Place(id: id, name: "Place \(id)", address: "some place", type: .casino, imageUrl: randomImageUrl)
            
            return place
        }
        
        required init(httpClient: AsyncHttpClient) {
            super.init(httpClient: httpClient)
            
            Task {
                await MainActor.run {
                    places = (1...5).map { id in
                            .init(id: String(id), name: "Place \(id)", address: "somewhere", type: .casino, imageUrl: Self.randomImageUrl)
                    }
                }
            }
        }
        
    }
    
    class ViewModel: ObservableObject {
        
        required internal init(httpClient: AsyncHttpClient) {
            self.httpClient = httpClient
            
            $keyword
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main, options: nil)
                .removeDuplicates()
                .sink { [self] key in
                    Task {
                        await searchPlaces(keyword: key)
                    }
                }
                .store(in: &bag)
        }
        
        private typealias Endpoint = APIs.Places
        
        @MainActor @Published var places: [Place] = []
        @MainActor @Published var error: Error?
        @MainActor @Published var isLoading: Bool = false
        
        @Published var keyword: String = ""
        
        private let httpClient: AsyncHttpClient
        
        private var bag = Set<AnyCancellable>()
        
        // MARK: - API
        
        func searchPlaces(page: Int = 0, pageSize: Int = 20, keyword: String? = nil) async {
            
            let query = Places.SearchQuery(type: nil, keyword: keyword, page: page, perPage: pageSize)
            
            do {
                await MainActor.run {
                    isLoading = true
                }
                let response: PagingEnvelop<Place> = try await httpClient.request(url: Endpoint.searchPlaces, method: .get(queryItemsProvider: query))
                await MainActor.run {
                    isLoading = false
                    places = response.data.items
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    self.error = error
                }
            }
        }
        
    }
    
}
