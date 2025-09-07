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
    
    func testModifyTask_ShouldUpdateTaskTitleAndPriority() throws {
        // Given - First create a task to modify
        let initialTask = Task(
            id: UUID(),
            title: "Initial Task",
            taskDescription: "Initial Description",
            category: .personal,
            priority: .low,
            taskType: .individual,
            dueDate: Date(),
            isCompleted: false
        )
        
        // Create the initial task
        _ = coreDataManager.createTask(initialTask)
        
        // Create view model for modification
        viewModel = CreateTaskViewModel(coreDataManager: coreDataManager, task: initialTask)
        
        let expectation = XCTestExpectation(description: "Modified task should be published in tasks array")
        var publishedTasks: [Task] = []
        
        // Set up modified test data - changing title and priority
        viewModel.title = "Modified Task"
        viewModel.selectedPriority = .high
        
        // Subscribe to tasks publisher, skip first emission since we already have the initial task
        coreDataManager.tasks
            .dropFirst() // Skip the current state with initial task
            .sink { tasks in
                publishedTasks = tasks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - Modify the task
        viewModel.createTask()
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(publishedTasks.count, 1, "Should have exactly one task")
        
        let modifiedTask = try XCTUnwrap(publishedTasks.first, "Should have a task in the array")
        XCTAssertEqual(modifiedTask.id, initialTask.id, "Task ID should remain the same")
        XCTAssertEqual(modifiedTask.title, "Modified Task")
        XCTAssertEqual(modifiedTask.priority, .high)
        XCTAssertFalse(modifiedTask.isCompleted)
    }
    
    func testDeleteTask_ShouldRemoveTaskFromPublisher() throws {
        // Given - First create a task to delete
        let taskToDelete = Task(
            id: UUID(),
            title: "Task to Delete",
            taskDescription: "This task will be deleted",
            category: .work,
            priority: .medium,
            taskType: .individual,
            dueDate: Date(),
            isCompleted: false
        )
        
        let createExpectation = XCTestExpectation(description: "Task should be created and published")
        var createdTasks: [Task] = []
        
        // Subscribe to tasks publisher to verify task creation
        coreDataManager.tasks
            .dropFirst() // Skip initial empty array
            .sink { tasks in
                createdTasks = tasks
                createExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Create the initial task
        _ = coreDataManager.createTask(taskToDelete)
        
        // Verify task was created
        wait(for: [createExpectation], timeout: 2.0)
        XCTAssertEqual(createdTasks.count, 1, "Should have one task after creation")
        XCTAssertEqual(createdTasks.first?.id, taskToDelete.id, "Should have the created task")
        
        // Create view model for deletion (modify mode)
        viewModel = CreateTaskViewModel(coreDataManager: coreDataManager, task: taskToDelete)
        
        let deleteExpectation = XCTestExpectation(description: "Task should be removed from tasks array")
        var publishedTasks: [Task] = []
        
        // Subscribe to tasks publisher for deletion verification
        coreDataManager.tasks
            .dropFirst() // Skip the current state with the task
            .sink { tasks in
                publishedTasks = tasks
                deleteExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - Delete the task
        viewModel.deleteTask()
        
        // Then - Verify task was deleted
        wait(for: [deleteExpectation], timeout: 2.0)
        
        XCTAssertEqual(publishedTasks.count, 0, "Should have no tasks after deletion")
    }
    
}
