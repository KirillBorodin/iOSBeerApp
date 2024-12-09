//
//  AppDependencies.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.12.2024.
//

import os

struct AppDependencies {
    
    private let logger = Logger(subsystem: "iOSBeerApp", category: "AppDependencies")
    
    // Common Dependencies
    let isInternetConnectionAvailableUseCase: IsInternetConnectionAvailableUseCase
    
    // Beers Dependencies
    let getBeersUseCase: GetBeersUseCase
    
    init() {
        logger.info("Initializing dependencies...")
        
        // Common Module
        let hostDeviceDataSource = HostDeviceLocalDataSource()
        let hostDeviceRepository = HostDeviceRepository(localDataSource: hostDeviceDataSource)
        self.isInternetConnectionAvailableUseCase = IsInternetConnectionAvailableUseCase(repository: hostDeviceRepository)
        
        logger.info("Initialized Common Module dependencies.")
        
        // Beers Module
        let remoteDataSource = OpenBreweryRemoteDataSource()
        let localDataSource = CoreDataLocalDataSource()
        let repository = BeersRepository(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        self.getBeersUseCase = GetBeersUseCase(
            repository: repository, isInternetConnectionAvailableUseCase: isInternetConnectionAvailableUseCase
        )
        logger.info("Initialized Beers Module dependencies.")
    }
}
