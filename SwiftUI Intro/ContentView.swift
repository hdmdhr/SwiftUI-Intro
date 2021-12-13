//
//  ContentView.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {

    @State private var bag = Set<AnyCancellable>()
    @State private var places: [Places.Place] = []
    
    var body: some View {
        List(places, id: \.id) { place in
            Text("\(place.name)\n\(place.address)")
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif
        }
        .onAppear(perform: {
            let httpClient = EndpointHttpClient(urlSession: .shared, endpointType: APIs.Places.self)
            httpClient.networkRequestPublisher(endpoint: .searchPlaces,
                                               method: .get(queryItemsProvider: Places.SearchQuery()))
                .map{ (env: PagingEnvelop<Places.Place>) in
                    env.data.items
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let networkError):
                        print(networkError.description)
                    case .finished: break
                    }
                }, receiveValue: { places in
                    self.places = places
                })
                .store(in: &bag)
        })
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
