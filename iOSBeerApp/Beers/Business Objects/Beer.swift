//
//  Beer.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import CoreData
struct Beer : Identifiable {
    let id: String
    let name: String
    let breweryType: String?
    let address1: String?
    let city: String
    let stateProvince: String?
    let postalCode: String
    let country: String
    let phone: String?
    let websiteURL: String?
    let state: String?
    let street: String?
    let longitude: String?
    let latitude: String?
}


extension Beer {
    @discardableResult
    func toEntity(context: NSManagedObjectContext) -> BeerEntity {
        let beerEntity = BeerEntity(context: context)
        beerEntity.id = id
        beerEntity.name = name
        beerEntity.breweryType = breweryType
        beerEntity.city = city
        beerEntity.address1 = address1
        beerEntity.phone = phone
        beerEntity.websiteURL = websiteURL
        beerEntity.stateProvince = stateProvince
        beerEntity.postalCode = postalCode
        beerEntity.country = country
        beerEntity.state = state
        beerEntity.street = street
        beerEntity.longitude = longitude
        beerEntity.latitude = latitude
        return beerEntity
    }
}
