import Foundation
import CoreData
@testable import StayOrganised

class CoreDataFactoryMock: CoreDataFactoryProtocol {
    
    let mockCoreDataService: CoreDataServiceMock
    let mockTaskParser: TaskParserMock
    let mockContainer: NSPersistentContainer
    
    init() {
        self.mockCoreDataService = CoreDataServiceMock()
        self.mockTaskParser = TaskParserMock()
        
        // Create in-memory persistent container for testing
        self.mockContainer = NSPersistentContainer(name: "StayOrganisedModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockContainer.persistentStoreDescriptions = [description]
        mockContainer.loadPersistentStores { _, _ in }
    }
    
    func createCoreDataService(context: NSManagedObjectContext) -> CoreDataServiceProtocol {
        return mockCoreDataService
    }
    
    func createCoredataParser(context: NSManagedObjectContext) -> TaskParserProtocol {
        return mockTaskParser
    }
    
    func createPersistentContainer() -> NSPersistentContainer {
        return mockContainer
    }
}