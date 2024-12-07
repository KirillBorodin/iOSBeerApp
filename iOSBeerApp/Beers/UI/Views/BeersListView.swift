//
//  L.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//
import SwiftUI

struct BeerListView: View {
    let beers: [Beer]
    
    var body: some View {
        List(beers) { beer in
            BeerItemView(beer: beer)
        }
    }
}
