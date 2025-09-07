import Foundation
import CoreData
@testable import StayOrganised

class CoreDataServiceMock: CoreDataServiceProtocol {
    
    // Callbacks that tests can set
    var fetchTasksCallback: (() -> [TaskEntity])?
    var fetchTasksWithDatesCallback: ((Date, Date) -> [TaskEntity])?
    var fetchTaskCallback: ((UUID) throws -> TaskEntity?)?
    var createTaskCallback: ((TaskEntity) -> Bool)?
    var updateTaskCallback: ((TaskEntity) -> Bool)?
    var deleteTaskCallback: ((UUID) -> Bool)?
    var fetchTaskWithIDCallback: ((UUID) throws -> TaskEntity?)?
    
    func fetchTasks() -> [TaskEntity] {
        return fetchTasksCallback?() ?? []
    }
    
    func fetchTasks(startDate: Date, endDate: Date) -> [TaskEntity] {
        return fetchTasksWithDatesCallback?(startDate, endDate) ?? []
    }
    
    func fetchTask(id: UUID) throws -> TaskEntity {
        guard let taskEntity = try fetchTaskCallback?(id) else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return taskEntity
    }
    
    func createTask(_ task: TaskEntity) -> Bool {
        return createTaskCallback?(task) ?? false
    }
    
    func updateTask(_ task: TaskEntity) -> Bool {
        return updateTaskCallback?(task) ?? false
    }
    
    func deleteTask(withId id: UUID) -> Bool {
        return deleteTaskCallback?(id) ?? false
    }
}
