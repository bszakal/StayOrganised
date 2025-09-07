import XCTest
import Combine
@testable import StayOrganised

final class TaskListViewModelTests: XCTestCase {
    
    var taskListViewModel: TaskListViewModel!
    var mockCoreDataManager: CoreDataManagerMock!
    var mockCreateTaskViewModelFactory: CreateTaskViewModelFactoryMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Create mocks
        mockCoreDataManager = CoreDataManagerMock()
        mockCreateTaskViewModelFactory = CreateTaskViewModelFactoryMock()
        
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        taskListViewModel = nil
        mockCoreDataManager = nil
        mockCreateTaskViewModelFactory = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    func testFilteredTasks_ShouldPublishPendingTaskWithinDateRange() throws {
        // Given
        let testDate = Date()
        let startDate = Calendar.current.startOfDay(for: testDate)
        guard let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: testDate) else {
            XCTFail("Could not create end date")
            return
        }
        
        // Create a task that falls within the date range
        let pendingTask = Task(
            id: UUID(),
            title: "Pending Task",
            taskDescription: "Task within date range",
            category: .work,
            priority: .high,
            taskType: .individual,
            dueDate: testDate, // Within the date range
            isCompleted: false
        )
        
        // Create a task outside the date range
        let outsideRangeTask = Task(
            id: UUID(),
            title: "Outside Range Task",
            taskDescription: "Task outside date range",
            category: .work,
            priority: .medium,
            taskType: .individual,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: testDate) ?? testDate,
            isCompleted: false
        )
        
        // Create a completed task within range
        let completedTask = Task(
            id: UUID(),
            title: "Completed Task",
            taskDescription: "Completed task within range",
            category: .work,
            priority: .low,
            taskType: .individual,
            dueDate: testDate,
            isCompleted: true
        )
        
        // Initialize TaskListViewModel with specific date range and category
        taskListViewModel = TaskListViewModel(
            coreDataManager: mockCoreDataManager,
            createTaskViewModelFactory: mockCreateTaskViewModelFactory,
            startDate: startDate,
            endDate: endDate,
            category: .work
        )
        
        let expectation = XCTestExpectation(description: "Pending tasks should be filtered and published")
        var publishedPendingTasks: [Task] = []
        var publishedCompletedTasks: [Task] = []
        
        // Subscribe to pending tasks
        taskListViewModel.$pendingTasks
            .dropFirst() // Skip initial empty array
            .sink { tasks in
                publishedPendingTasks = tasks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Subscribe to completed tasks
        taskListViewModel.$completedTasks
            .sink { tasks in
                publishedCompletedTasks = tasks
            }
            .store(in: &cancellables)
        
        // When - Simulate CoreDataManager publishing tasks
        mockCoreDataManager.publishTasks([pendingTask, outsideRangeTask, completedTask])
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertEqual(publishedPendingTasks.count, 1, "Should have exactly one pending task within date range and category")
        XCTAssertEqual(publishedPendingTasks.first?.id, pendingTask.id, "Should be the pending task within range")
        XCTAssertEqual(publishedPendingTasks.first?.category, .work, "Should match the filtered category")
        XCTAssertFalse(publishedPendingTasks.first?.isCompleted ?? true, "Should be incomplete")
        
        XCTAssertEqual(publishedCompletedTasks.count, 1, "Should have exactly one completed task within date range and category")
        XCTAssertEqual(publishedCompletedTasks.first?.id, completedTask.id, "Should be the completed task within range")
        XCTAssertTrue(publishedCompletedTasks.first?.isCompleted ?? false, "Should be completed")
    }
}
