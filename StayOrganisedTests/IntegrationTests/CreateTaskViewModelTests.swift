import XCTest
import Combine
import CoreData
@testable import StayOrganised

final class CreateTaskViewModelTests: XCTestCase {
    
    var viewModel: CreateTaskViewModel!
    var coreDataManager: CoreDataManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create in-memory Core Data stack for testing
        let coreDataFactory = InMemoryCoreDataFactory()
        coreDataManager = CoreDataManager(coreDataFactory: coreDataFactory)
        
        // Create view model with test dependencies
        viewModel = CreateTaskViewModel(coreDataManager: coreDataManager, task: nil)
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        coreDataManager = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testCreateTask_ShouldCreateTaskAndPublishInTasksArray() throws {
        // Given
        let expectation = XCTestExpectation(description: "Task should be published in tasks array")
        var publishedTasks: [Task] = []
        
        // Set up test data
        viewModel.title = "Test Task"
        viewModel.taskDescription = "Test Description"
        viewModel.selectedCategory = .work
        viewModel.selectedPriority = .high
        viewModel.dueDate = Date()
        
        // Subscribe to tasks publisher
        coreDataManager.tasks
            .dropFirst() // Skip initial empty array
            .sink { tasks in
                publishedTasks = tasks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.createTask()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(publishedTasks.count, 1, "Should have exactly one task")
        
        let createdTask = try XCTUnwrap(publishedTasks.first, "Should have a task in the array")
        XCTAssertEqual(createdTask.title, "Test Task")
        XCTAssertEqual(createdTask.taskDescription, "Test Description")
        XCTAssertEqual(createdTask.category, .work)
        XCTAssertEqual(createdTask.priority, .high)
        XCTAssertEqual(createdTask.taskType, .individual)
        XCTAssertFalse(createdTask.isCompleted)
    }
    
    func testCreateTask_WithEmptyTitle_ShouldNotCreateTask() throws {
        // Given
        let expectation = XCTestExpectation(description: "No task should be published")
        expectation.isInverted = true // We expect this NOT to be fulfilled
        
        viewModel.title = "" // Empty title
        viewModel.taskDescription = "Test Description"
        
        // Subscribe to tasks publisher
        coreDataManager.tasks
            .dropFirst() // Skip initial empty array
            .sink { _ in
                expectation.fulfill() // This should not be called
            }
            .store(in: &cancellables)
        
        // When
        viewModel.createTask()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        // Test passes if expectation is not fulfilled (task not created)
    }
    
}
