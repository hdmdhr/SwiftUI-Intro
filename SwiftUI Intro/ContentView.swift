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
    var isPreview = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(place.name)
                
                Spacer()
                
                Text(place.type.rawValue)
                    .foregroundColor(.secondary)
            }
            
            Text(place.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AsyncImage(url: place.imageUrl) { image in
                image.resizable()
                    .scaledToFill()
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)
                    .padding(.vertical)
            } placeholder: {
                if isPreview {
                    Image(systemName: "applelogo")
                        .resizable()
                        .scaledToFill()
                        .background(Color.gray)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                        .shadow(radius: 7)
                        .frame(width: 200, height: 200, alignment: .center)
                } else {
                    ProgressView()
                        .frame(width: 200, height: 200, alignment: .center)
                }
            }
        }
        .padding()
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(vm: ContentView.FakeViewModel(httpClient: AsyncHttpClient(urlSession: .shared)))
            
            PlaceRow(place: ContentView.FakeViewModel.randomPlace(),
                     isPreview: true)
                .previewDisplayName("Light mode place row")
                .previewLayout(.sizeThatFits)
            
            PlaceRow(place: ContentView.FakeViewModel.randomPlace(),
                     isPreview: true)
                .previewDisplayName("Dark mode place row")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
