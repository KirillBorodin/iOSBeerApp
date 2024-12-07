//
//  GetBeersUseCase.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

class GetBeersUseCase {
    private let repository: BeersRepository
    
    init(repository: BeersRepository) {
        self.repository = repository
    }
    
    func execute(page: Int) async -> Result<[Beer], Error> {
        do {
            let beers = try await repository.getBeers(page: page)
            return .success(beers)
        } catch {
            return .failure(error)
        }
    }
}
