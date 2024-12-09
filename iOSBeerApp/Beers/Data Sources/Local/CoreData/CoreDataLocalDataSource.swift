//
//  CoreDataLocalDataSource.swift
//  iOSBeerApp
//
//  Created by Kirill on 08.12.2024.
//
import CoreData
import os

class CoreDataLocalDataSource: BeersLocalDataSource {
    
    static let shared = CoreDataLocalDataSource()
    
    private let logger = Logger(
        subsystem: "Beers.DataSources.Local.CoreData", category: "CoreDataLocalDataSource")
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        logger.info("Initializing Core Data stack...")
        
        persistentContainer = NSPersistentContainer(name: "BeerModel")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                self.logger.critical("Failed to load Core Data stack: \(error.localizedDescription)")
                fatalError("Failed to load Core Data stack: \(error)")
            } else {
                self.logger.info("Successfully loaded store: \(storeDescription.url?.absoluteString ?? "unknown location")")
            }
        }
    }
    
    func get(page: Int) async throws -> [Beer] {
        logger.info("Fetching beers for page \(page)...")
        
        guard page > 0 else {
            logger.error("Invalid page number: \(page). Must be greater than 0.")
            throw NSError(domain: "InvalidPage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Page number must be greater than 0"])
        }
        
        let fetchRequest: NSFetchRequest<BeerEntity> = BeerEntity.fetchRequest()
        fetchRequest.fetchLimit = 10 // Set page size
        fetchRequest.fetchOffset = (page - 1) * 10 // Calculate offset
        
        logger.info("FetchRequest configured with fetchLimit: \(fetchRequest.fetchLimit), fetchOffset: \(fetchRequest.fetchOffset)")
        
        let context = persistentContainer.viewContext
        return try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    self.logger.info("Starting fetch operation for page \(page)...")
                    let beerEntities = try context.fetch(fetchRequest)
                    let beers = beerEntities.map { $0.toBo() }
                    self.logger.info("Fetch operation completed. Retrieved \(beers.count) beers.")
                    continuation.resume(returning: beers)
                } catch {
                    self.logger.error("Failed to fetch beers for page \(page): \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func save(beers: [Beer]) async throws {
        logger.info("Attempting to save beers: \(beers.map { "\($0.name) (ID: \($0.id))" }.joined(separator: ", "))")
        guard !beers.isEmpty else {
            logger.error("Attempted to save an empty list of beers. Aborting.")
            return
        }
        
        let context = persistentContainer.viewContext
        
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                for beer in beers {
                    // Automatically creates NSManagedObject within the context
                    beer.toEntity(context: context)
                }
                
                do {
                    self.logger.info("Attempting to save changes to Core Data...")
                    try self.apply()
                    self.logger.info("Successfully saved \(beers.count) beers to Core Data.")
                    continuation.resume()
                } catch {
                    self.logger.error("Failed to save beers to Core Data: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func save(beer: Beer) async throws {
        try await save(beers: [beer])
    }
    
    
    private func apply() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
            self.logger.info("Applied changes to Core Data.")
        } else {
            self.logger.info("Nothing to apply to Core Data.")
        }
    }
}
