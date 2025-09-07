import XCTest
import Combine
import CoreData
@testable import StayOrganised

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var mockFactory: CoreDataFactoryMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create mock factory
        mockFactory = CoreDataFactoryMock()
        
        // Initialize CoreDataManager with mock factory
        coreDataManager = CoreDataManager(coreDataFactory: mockFactory)
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        coreDataManager = nil
        mockFactory = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testCreateTask_ShouldAddTaskToPublisher_WhenParsingAndCreationSucceed() throws {
        // Given
        let taskToCreate = Task(
            id: UUID(),
            title: "Test Task",
            taskDescription: "Test Description",
            category: .work,
            priority: .high,
            taskType: .individual,
            dueDate: Date(),
            isCompleted: false
        )
        
        let mockTaskEntity = TaskEntity(context: mockFactory.mockContainer.viewContext)
        mockTaskEntity.id = taskToCreate.id
        mockTaskEntity.title = taskToCreate.title
        
        // Set up parser mock to return TaskEntity when converting from Task
        mockFactory.mockTaskParser.convertToCoreDataModelCallback = { task in
            return mockTaskEntity
        }
        
        // Set up service mock to return success for createTask
        mockFactory.mockCoreDataService.createTaskCallback = { _ in
            return true
        }
        
        // Set up service mock to return the created task when fetching
        mockFactory.mockCoreDataService.fetchTasksCallback = {
            return [mockTaskEntity]
        }
        
        // Set up parser mock to convert back to business model
        mockFactory.mockTaskParser.convertToBusinessModelCallback = { entity in
            return taskToCreate
        }
        
        let expectation = XCTestExpectation(description: "Task should be published in tasks array")
        var publishedTasks: [Task] = []
        
        // Subscribe to tasks publisher
        coreDataManager.tasks
            .dropFirst() // Skip initial empty array
            .sink { tasks in
                publishedTasks = tasks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        let result = coreDataManager.createTask(taskToCreate)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(result, "createTask should return true on success")
        XCTAssertEqual(publishedTasks.count, 1, "Should have exactly one task")
        XCTAssertEqual(publishedTasks.first?.id, taskToCreate.id, "Should have the created task")
    }
}