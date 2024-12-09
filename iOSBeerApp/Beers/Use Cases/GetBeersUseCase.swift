//
//  GetBeersUseCase.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

class GetBeersUseCase {
    private let repository: BeersRepository
    private let isInternetConnectionAvailableUseCase: IsInternetConnectionAvailableUseCase
    
    init(repository: BeersRepository, isInternetConnectionAvailableUseCase: IsInternetConnectionAvailableUseCase) {
        self.repository = repository
        self.isInternetConnectionAvailableUseCase = isInternetConnectionAvailableUseCase
    }
    
    /// Fetch beers for the given page.
    /// - Parameter page: The page number for pagination.
    /// - Returns: A `Result` containing an array of `Beer` objects or an `Error`.
    func execute(page: Int) async -> Result<[Beer], Error> {
        let isConnected = (try? isInternetConnectionAvailable()) ?? false
        
        if !isConnected {
            return await getBeers(page: page, isLocalOnly: true)
        }
        
        return await getBeers(page: page)
    }
    
    /// Fetch beers from the repository.
    /// - Parameters:
    ///   - page: The page number for pagination.
    ///   - isLocalOnly: Whether to fetch only local data.
    /// - Returns: A `Result` containing an array of `Beer` objects or an `Error`.
    private func getBeers(page: Int, isLocalOnly: Bool = false) async -> Result<[Beer], Error> {
        do {
            let beers = try await repository.get(page: page, isLocalOnly: isLocalOnly)
            return .success(beers)
        } catch {
            return .failure(error)
        }
    }
    
    /// Check if internet connection is available.
    /// - Returns: A `Bool` indicating internet availability.
    /// - Throws: An error if the check fails.
    private func isInternetConnectionAvailable() throws -> Bool {
        let result = isInternetConnectionAvailableUseCase.execute()
        return try result.get()
    }
}
