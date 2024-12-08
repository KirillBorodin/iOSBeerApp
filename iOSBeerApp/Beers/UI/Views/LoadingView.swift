//
//  LoadingView.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading Beers...")
                .padding()
        }
    }
}

#Preview("Loading State") {
    BeersScreen(viewModel: MockBeersViewModel(state: .loading))
}
