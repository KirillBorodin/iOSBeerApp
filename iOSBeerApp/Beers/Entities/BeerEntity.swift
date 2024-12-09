//
//  BeerEntity.swift
//  iOSBeerApp
//
//  Created by Kirill on 08.12.2024.
//

import CoreData

@objc(BeerEntity)
class BeerEntity: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var breweryType: String?
    @NSManaged public var address1: String?
    @NSManaged public var city: String
    @NSManaged public var stateProvince: String?
    @NSManaged public var postalCode: String
    @NSManaged public var country: String
    @NSManaged public var phone: String?
    @NSManaged public var websiteURL: String?
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var longitude: String?
    @NSManaged public var latitude: String?
}

extension BeerEntity {
    func toBo() -> Beer {
        .init(id: id, name: name, breweryType: breweryType, address1: address1, city: city, stateProvince: stateProvince, postalCode: postalCode, country: country, phone: phone, websiteURL: websiteURL, state: state, street: street, longitude: longitude, latitude: latitude)
    }
}

extension BeerEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BeerEntity> {
            return NSFetchRequest<BeerEntity>(entityName: "BeerEntity")
   }
}
