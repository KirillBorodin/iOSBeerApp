//
//  BeersRepository.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

class BeersRepository {
    let remoteDataSource: BeersRemoteDataSource
    
    init(remoteDataSource: BeersRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    /// Fetch beers from the remote data source.
    /// - Parameter page: The page number for pagination.
    /// - Returns: An array of `Beer` objects.
    func getBeers(page: Int) async throws -> [Beer] {
        return try await remoteDataSource.getBeers(page: page)
    }
}
