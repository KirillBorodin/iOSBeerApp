//
//  BeersView.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import SwiftUI

struct BeersView: View {
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
            BeerListView(beers: beers)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading Beers...")
                .padding()
        }
    }
}

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            Text(errorMessage)
                .foregroundColor(.secondary)
            Button("Retry", action: retryAction)
                .padding(.top)
        }
    }
}

struct BeerListView: View {
    let beers: [Beer]
    
    var body: some View {
        List(beers) { beer in
            BeerRowView(beer: beer)
        }
    }
}

struct BeerRowView: View {
    let beer: Beer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main title
            Text(beer.name)
                .font(.headline)
            
            if let breweryType = beer.breweryType {
                Text("\(breweryType.capitalized) • \(beer.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Unknown Type • \(beer.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Address
            if let address = beer.address1 {
                Text("📍 \(address), \(beer.city)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                Text("📍 \(beer.city)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Phone
            if let phone = beer.phone {
                Text("📞 \(phone)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Website
            if let website = beer.websiteURL, let url = URL(string: website) {
                Link("🌐 Visit Website", destination: url)
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}
