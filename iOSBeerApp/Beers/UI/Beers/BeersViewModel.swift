//
//  BeersViewModel.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import Combine
import Foundation

class BeersViewModel: ObservableObject {
    
    @Published var state: BeersViewState = .loading
    private var page = 1
    
    private let getBeersUseCase: GetBeersUseCase
    
    init(getBeersUseCase: GetBeersUseCase) {
        self.getBeersUseCase = getBeersUseCase
    }
    
    func getBeers(isLoadMore: Bool = false) {
        if isLoadMore {
            self.page += 1 // Increment page for load more
        } else {
            self.page = 1 // Reset page for initial load
            self.state = .loading
        }
        
        fetchBeers()
    }
    
    private func fetchBeers() {
        Task {
            let result = await getBeersUseCase.execute(page: page) // Runs on a background thread
            await MainActor.run { // Switch back to Main Thread for UI updates
                switch result {
                case .success(let beers):
                    handleNewBeers(beers)
                case .failure(let error):
                    handleCompletion(.failure(error))
                }
            }
        }
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            self.state = .error(error.localizedDescription)
        }
    }
    
    private func handleNewBeers(_ newBeers: [Beer]) {
        switch self.state {
        case .loading, .error:
            // Replace state with new beers for loading or after an error
            self.state = .loaded(newBeers)
        case .loaded(let existingBeers):
            // Append new beers for pagination
            self.state = .loaded(existingBeers + newBeers)
        }
    }
}


enum BeersViewState {
    case loading
    case error(String)
    case loaded([Beer])
}
