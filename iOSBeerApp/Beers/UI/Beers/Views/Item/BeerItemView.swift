//
//  BeerItemView.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import SwiftUI
import MapKit

struct BeerItemView: View {
    let beer: Beer
    
    var body: some View {
        // Website
        if let website = beer.websiteURL, let url = URL(string: website) {
            NavigationLink(destination: BeerScreen(url: url)) {
                BeerItemContentView(beer: beer)
            }
        } else {
            BeerItemContentView(beer: beer)
        }
    }
}



