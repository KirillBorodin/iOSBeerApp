//
//  iOSBeerAppApp.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import SwiftUI

@main
struct iOSBeerApp: App {
    
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            BeersScreen(viewModel: BeersViewModel(getBeersUseCase: dependencies.getBeersUseCase))
        }
    }
}
