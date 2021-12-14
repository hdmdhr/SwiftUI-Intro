//
//  ContentView.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import SwiftUI

struct ContentView: View {

    @StateObject var vm: ViewModel
    
    var body: some View {
        
        NavigationView {
            ZStack {
                List(vm.places, id: \.id) { place in
                    PlaceRow(place: place)
                }
                .searchable(text: $vm.keyword)

                if vm.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(.circular)
                }                
            }
            .navigationTitle("Places")
        }
        
    }

}

struct PlaceRow: View {
    
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(place.name)\n\(place.address)")
            
            AsyncImage(url: place.imageUrl) { image in
                image.resizable()
                    .scaledToFill()
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)
            } placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200, alignment: .center)
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(vm: ContentView.FakeViewModel(httpClient: AsyncHttpClient(urlSession: .shared)))
            
            PlaceRow(place: ContentView.FakeViewModel.randomPlace())
                .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/200.0/*@END_MENU_TOKEN@*/))
        }
    }
}
