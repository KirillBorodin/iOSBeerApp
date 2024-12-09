//
//  BeersRepository.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import os
import Foundation

class BeersRepository {
    let remoteDataSource: BeersRemoteDataSource
    let localDataSource: BeersLocalDataSource
    
    private let logger = Logger(subsystem: "Beers.Repository", category: "BeersRepository")
    
    init(remoteDataSource: BeersRemoteDataSource, localDataSource: BeersLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    /// Fetch beers for the given page.
    /// - Parameter page: The page number for pagination.
    /// - Returns: An array of `Beer` objects.
    func get(page: Int) async throws -> [Beer] {
        guard page > 0 else {
            logger.error("Invalid page number: \(page). Must be greater than 0.")
            throw NSError(domain: "InvalidPage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Page number must be greater than 0"])
        }
        
        logger.info("Getting beers for page \(page)...")
        
        
        let localBeers = try await localDataSource.get(page: page)
        
        if !localBeers.isEmpty {
            logger.info("Returning local data for page \(page).")
            return localBeers
        }
        
        logger.info("Fetching data from remote for page \(page)...")
        let remoteBeers = try await remoteDataSource.get(page: page)
        
        logger.info("Saving remote data to local for page \(page)...")
        try await localDataSource.save(beers: remoteBeers)
        
        
        return remoteBeers
    }
}
