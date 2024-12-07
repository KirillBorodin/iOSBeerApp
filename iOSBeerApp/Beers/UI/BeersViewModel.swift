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
    private var cancellables = Set<AnyCancellable>()
    
    init(getBeersUseCase: GetBeersUseCase) {
        self.getBeersUseCase = getBeersUseCase
    }
    
    func getBeers(isLoadMore: Bool = false) {
        if !isLoadMore {
            self.page = 1
            self.state = .loading
        }
        

        Deferred {
            Future<[Beer], Error> { promise in
                Task {
                    let result = await self.getBeersUseCase.execute(page: self.page)
                    switch result {
                    case .success(let beers):
                        promise(.success(beers))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
        .sink(
            receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .error(error.localizedDescription)
                }
            },
            receiveValue: { [weak self] newBeers in
                guard let self = self else { return }
                    switch self.state {
                    case .loading:
                        // Initial load, set state to loaded with new beers
                        self.state = .loaded(newBeers)
                    case .loaded(let existingBeers):
                        // Pagination: Append new beers to existing ones
                        self.state = .loaded(existingBeers + newBeers)
                    case .error:
                        // Do nothing if an error occurs
                        break
                    }
                if(isLoadMore) {
                    page += 1
                }
            }
        )
        .store(in: &cancellables)
    }
}


enum BeersViewState {
    case loading
    case error(String)
    case loaded([Beer])
}
