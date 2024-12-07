//
//  OpenBreweryRemoteDataSource.swift
//  iOSBeerApp
//
//  Created by Kirill on 07.12.2024.
//

import Foundation
import os

class OpenBreweryRemoteDataSource: BeersRemoteDataSource {
    
    private let baseUrl = "https://api.openbrewerydb.org/v1/breweries"
    private let perPage: Int = 50
    private let logger = Logger(
        subsystem: "Beers.DataSources.Remote.OpenBrewery", category: "OpenBreweryRemoteDataSource")
    
    func getBeers(page: Int) async throws -> [Beer] {
        logger.info("Constructing URL for page \(page) with \(self.perPage) items per page.")
        
        guard var components = URLComponents(string: baseUrl) else {
            let errorMessage = "Invalid base URL"
            logger.error("\(errorMessage, privacy: .public)")
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        guard let url = components.url else {
            let errorMessage = "Failed to construct URL with page: \(page)"
            logger.error("\(errorMessage, privacy: .public)")
            throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        logger.info("Fetching data from URL: \(url.absoluteString, privacy: .public)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                logger.info("Received HTTP response: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    let errorMessage = "Unexpected response status code: \(httpResponse.statusCode)"
                    logger.error("\(errorMessage, privacy: .public)")
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
            }
            
            // Log: Raw JSON response
             if let jsonString = String(data: data, encoding: .utf8) {
                 logger.info("JSON Response: \(jsonString, privacy: .public)")
             } else {
                 logger.warning("Unable to decode JSON response into a string.")
             }
            
            logger.info("Received data of size: \(data.count) bytes.")
            
            let beersDto = try JSONDecoder().decode([BeerDto].self, from: data)
            logger.info("Successfully decoded \(beersDto.count) items.")
            
            return beersDto.map { $0.toBo() }
            
        } catch let decodingError as DecodingError {
            let errorMessage = "Failed to decode BeerDto from API response: \(decodingError.localizedDescription)"
            logger.error("\(errorMessage, privacy: .public)")
            throw URLError(.cannotDecodeRawData, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } catch {
            logger.error("Unexpected error: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }
}
