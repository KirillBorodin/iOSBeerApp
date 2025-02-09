//
//  BeerItemContentView.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.02.2025.
//
import SwiftUI
import MapKit

struct BeerItemContentView: View {
    
    let beer: Beer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main title
            Text(beer.name)
                .font(.headline)
            
            if let breweryType = beer.breweryType {
                Text("\(breweryType.capitalized) • \(beer.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            } else {
                Text("Unknown Type • \(beer.city)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Address
            if let address = beer.address1 {
                HStack {
                    Text("📍 \(address), \(beer.city)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "arrow.turn.up.right")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            openInAppleMaps(
                                address: address,
                                city: beer.city,
                                latitude: beer.latitude,
                                longitude: beer.longitude
                            )
                        }
                }
                
            } else {
                Text("📍 \(beer.city)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Phone
            if let phone = beer.phone {
                Text("📞 \(phone)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            // Website
            if let website = beer.websiteURL, let _ = URL(string: website) {
                Text("🌐 Visit Website")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
    
    func openInAppleMaps(address: String?, city: String?, latitude: String?, longitude: String?) {
        if let lat = latitude, let lon = longitude, let latDouble = Double(lat), let lonDouble = Double(lon) {
            // Open Apple Maps with coordinates
            let coordinate = CLLocationCoordinate2D(latitude: latDouble, longitude: lonDouble)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(address ?? ""), \(city ?? "")"
            mapItem.openInMaps(launchOptions: nil)
        } else if let address = address, let city = city {
            // Open Apple Maps with address and city
            let addressString = "\(address), \(city)"
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    print("Failed to geocode address: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                mapItem.name = addressString
                mapItem.openInMaps(launchOptions: nil)
            }
        } else {
            print("No valid address or coordinates provided.")
        }
    }
}
