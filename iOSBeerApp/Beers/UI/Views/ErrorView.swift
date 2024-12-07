//
//  ErrorView.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import SwiftUI

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
