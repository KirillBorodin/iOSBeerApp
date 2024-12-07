//
//  BeerDto.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import Foundation

struct BeerDto: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case breweryType = "brewery_type"
        case address1 = "address_1"
        case city
        case stateProvince = "state_province"
        case postalCode = "postal_code"
        case country, phone
        case websiteURL = "website_url"
        case state, street
    }
}

extension BeerDto {
    func toBo() -> Beer {
        .init(id: id, name: name, breweryType: breweryType, address1: address1, city: city, stateProvince: stateProvince, postalCode: postalCode, country: country, phone: phone, websiteURL: websiteURL, state: state, street: street)
    }
}
