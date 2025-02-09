//
//  L.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import SwiftUI

struct BeerListView: View {
    let beers: [Beer]
    let viewModel: BeersViewModel
    
    var body: some View {
        List {
            ForEach(beers) { beer in
                BeerItemView(beer: beer)
            }
            
            // Pagination Loader
            if !beers.isEmpty {
                HStack {
                    Spacer()
                    ProgressView("Loading more...")
                    Spacer()
                }
                .onAppear {
                    viewModel.getBeers(isLoadMore: true)
                }
            }
        }
    }
}

#Preview("Loaded State") {
    BeersScreen(viewModel: MockBeersViewModel(state: .loaded(Beer.sampleBeers)))
}
