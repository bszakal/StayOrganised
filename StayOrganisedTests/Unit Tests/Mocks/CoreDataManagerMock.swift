import Foundation
import Combine
@testable import StayOrganised

class CoreDataManagerMock: CoreDataManagerProtocol {
    
    // Callbacks that tests can set
    var createTaskCallback: ((Task) -> Bool)?
    var updateTaskCallback: ((Task) -> Bool)?
    var deleteTaskCallback: ((Task) -> Bool)?
    var deleteTaskWithIdCallback: ((UUID) -> Bool)?
    var toggleTaskCompletionCallback: ((Task) -> Bool)?
    
    // Publisher for tasks
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    var tasks: AnyPublisher<[Task], Never> {
        tasksSubject.eraseToAnyPublisher()
    }
    
    // Method to simulate publishing tasks
    func publishTasks(_ tasks: [Task]) {
        tasksSubject.send(tasks)
    }
    
    func createTask(_ task: Task) -> Bool {
        return createTaskCallback?(task) ?? false
    }
    
    func updateTask(_ task: Task) -> Bool {
        return updateTaskCallback?(task) ?? false
    }
    
    func deleteTask(_ task: Task) -> Bool {
        return deleteTaskCallback?(task) ?? false
    }
    
    func deleteTask(withId id: UUID) -> Bool {
        return deleteTaskWithIdCallback?(id) ?? false
    }
    
    func toggleTaskCompletion(_ task: Task) -> Bool {
        return toggleTaskCompletionCallback?(task) ?? false
    }
}