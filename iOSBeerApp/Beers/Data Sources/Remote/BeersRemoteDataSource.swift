//
//  BeersRemoteDataSource.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

protocol BeersRemoteDataSource {
    func getBeers(page: Int) async throws -> [Beer]
}
