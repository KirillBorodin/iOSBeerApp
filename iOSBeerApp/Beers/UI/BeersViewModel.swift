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
    
    private let getBeersUseCase: GetBeersUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getBeersUseCase: GetBeersUseCase) {
        self.getBeersUseCase = getBeersUseCase
    }
    
    func getBeers(page: Int) {
        self.state = .loading

        Deferred {
            Future<[Beer], Error> { promise in
                Task {
                    let result = await self.getBeersUseCase.execute(page: page)
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
            receiveValue: { [weak self] beers in
                self?.state = .loaded(beers)
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
