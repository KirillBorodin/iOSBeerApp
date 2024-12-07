//
//  BeersView.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import SwiftUI

struct BeersScreen: View {
    @StateObject var viewModel: BeersViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Beers")
                .onAppear {
                    viewModel.getBeers(page: 1)
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            LoadingView()
        case .error(let errorMessage):
            ErrorView(errorMessage: errorMessage) {
                viewModel.getBeers(page: 1)
            }
        case .loaded(let beers):
            BeerListView(beers: beers).refreshable {
                if case .loading = viewModel.state {
                    // Avoid re-fetching if already loaded
                    return
                }
                viewModel.getBeers(page: 1)
            }
        }
    }
}
