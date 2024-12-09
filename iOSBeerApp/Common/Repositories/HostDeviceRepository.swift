//
//  HostDeviceRepository.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.12.2024.
//

import Foundation

class HostDeviceRepository {
    private let localDataSource: HostDeviceLocalDataSource

    init(localDataSource: HostDeviceLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    /// Check if the internet connection is available.
    /// - Returns: A `Bool` indicating whether the internet connection is available.
    func isInternetConnectionAvailable() -> Bool {
        return localDataSource.isInternetConnectionAvailable()
    }
}
