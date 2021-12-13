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
                    Text("\(place.name)\n\(place.address)")
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ContentView.ViewModel(httpClient: AsyncHttpClient(urlSession: .shared)))
    }
}
