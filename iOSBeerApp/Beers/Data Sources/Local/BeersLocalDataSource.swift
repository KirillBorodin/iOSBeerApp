//
//  Untitled.swift
//  iOSBeerApp
//
//  Created by Kirill on 08.12.2024.
//

protocol BeersLocalDataSource {
    func get(page: Int) async throws -> [Beer]
    
    func save(beers: [Beer]) async throws
    
    func save(beer: Beer) async throws
}
