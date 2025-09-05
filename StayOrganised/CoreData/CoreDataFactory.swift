//
//  CoreDataFactory.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import Foundation
import CoreData

protocol CoreDataFactoryProtocol: CoreDataServiceFactoryProtocol, TaskParserFactoryProtocol {
    
}

protocol CoreDataServiceFactoryProtocol {
    func createCoreDataService(context: NSManagedObjectContext) -> CoreDataServiceProtocol
}

protocol TaskParserFactoryProtocol {
    func createCoredataParser(context: NSManagedObjectContext) -> TaskParserProtocol
}

class CoreDataFactory: CoreDataFactoryProtocol {
    
    func createCoredataParser(context: NSManagedObjectContext) -> any TaskParserProtocol {
        TaskParser(context: context)
    }
    
    func createCoreDataService(context: NSManagedObjectContext) -> any CoreDataServiceProtocol {
        CoreDataService(context: context)
    }
    
}
