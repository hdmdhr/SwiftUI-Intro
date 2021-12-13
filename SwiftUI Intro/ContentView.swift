//
//  ContentView.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import SwiftUI

struct ContentView: View {

    @State private var places: [Places.Place] = []
    
    var body: some View {
        List(places, id: \.id) { place in
            Text("\(place.name)\n\(place.address)")
        }
        .task {
            let httpClient = AsyncHttpClient(urlSession: .shared)
            
            guard let response: PagingEnvelop<Places.Place> = try? await httpClient.request(
                url: APIs.Places.searchPlaces,
                method: .get(queryItemsProvider: Places.SearchQuery()))
            else { return }
            
            self.places = response.data.items
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
