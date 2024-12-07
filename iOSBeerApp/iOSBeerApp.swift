//
//  iOSBeerAppApp.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import SwiftUI

@main
struct iOSBeerApp: App {
    var body: some Scene {
        WindowGroup {
            // Dependency injection for BeersViewModel
            let remoteDataSource = OpenBreweryRemoteDataSource()
            let repository = BeersRepository(remoteDataSource: remoteDataSource)
            let getBeersUseCase = GetBeersUseCase(repository: repository)
            BeersView(viewModel: BeersViewModel(getBeersUseCase: getBeersUseCase))
        }
    }
}
