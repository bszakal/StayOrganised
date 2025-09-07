//
//  CoreDataFactoryMock.swift
//  StayOrganisedTests
//
//  Created by Benjamin Szakal on 07/09/2025.
//

import Foundation
import CoreData
@testable import StayOrganised

class InMemoryCoreDataFactory: CoreDataFactoryProtocol {
    
    func createCoredataParser(context: NSManagedObjectContext) -> TaskParserProtocol {
        TaskParser(context: context)
    }
    
    func createCoreDataService(context: NSManagedObjectContext) -> CoreDataServiceProtocol {
        CoreDataService(context: context)
    }
    
    func createPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "StayOrganisedModel")
        
        // Use in-memory store for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error in tests: \(error)")
            }
        }
        
        return container
    }
}
