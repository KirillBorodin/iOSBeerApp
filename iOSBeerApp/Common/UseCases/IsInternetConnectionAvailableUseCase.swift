//
//  IsInternetConnectionAvailableUseCase.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.12.2024.
//
import os

class IsInternetConnectionAvailableUseCase {
    private let repository: HostDeviceRepository
    
    init(repository: HostDeviceRepository) {
        self.repository = repository
    }
    
    /// Execute the use case to check internet connection availability.
    ///
    /// - Returns: A `Result` wrapping a `Bool` (indicating internet availability).
    func execute() -> Result<Bool, Error> {
        let isConnected = repository.isInternetConnectionAvailable()
        return .success(isConnected)
    }
}
