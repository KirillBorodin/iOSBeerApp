//
//  BeersScreenPreviewProvider.swift
//  iOSBeerApp
//
//  Created by Kirill on 08.12.2024.
//

import SwiftUI

struct BeersView_Previews: PreviewProvider {
    static var previews: some View {
           Group {
               BeersScreen(viewModel: MockBeersViewModel(state: .loading))
                   .previewDisplayName("Loading State")

               BeersScreen(viewModel: MockBeersViewModel(state: .error("Failed to load beers.")))
                   .previewDisplayName("Error State")

               BeersScreen(viewModel: MockBeersViewModel(state: .loaded(Beer.sampleBeers)))
                   .previewDisplayName("Loaded State")
           }
       }
}

class MockBeersViewModel: BeersViewModel {
    init(state: BeersViewState) {
        super.init(getBeersUseCase: GetBeersUseCase(repository: BeersRepository(remoteDataSource: OpenBreweryRemoteDataSource())))
        self.state = state
    }
    
    override func getBeers(isLoadMore: Bool = false) {
           // No real API calls in previews
   }
}

extension Beer {
    static let sampleBeers: [Beer] = [
        Beer(
             id: "5128df48-79fc-4f0f-8b52-d06be54d0cec",
             name: "(405) Brewing Co",
             breweryType: "micro",
             address1: "1716 Topeka St",
             city: "Norman",
             stateProvince: "Oklahoma",
             postalCode: "73069-8224",
             country: "United States",
             phone: "4058160490",
             websiteURL: "http://www.405brewing.com",
             state: "Oklahoma",
             street: "1716 Topeka St",
             longitude: "-97.46818222",
             latitude: "35.25738891"
            ),
        Beer(
             id: "ef970757-fe42-416f-931d-722451f1f59c",
             name: "10 Barrel Brewing Co",
             breweryType: "large",
             address1: "1501 E St",
             city: "San Diego",
             stateProvince: "California",
             postalCode: "92101-6618",
             country: "United States",
             phone: "6195782311",
             websiteURL: "http://10barrel.com",
             state: "California",
             street: "1501 E St",
             longitude: "-117.129593",
             latitude: "32.714813"
            ),
    ]
}
