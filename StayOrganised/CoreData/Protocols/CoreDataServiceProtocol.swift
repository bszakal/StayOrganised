import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetchTasks(startDate: Date, endDate: Date) -> [TaskEntity]
    func fetchTasks() -> [TaskEntity]
    func fetchTask(id: UUID) throws -> TaskEntity
    func createTask(_ task: TaskEntity) -> Bool
    func updateTask(_ task: TaskEntity) -> Bool
    func deleteTask(withId id: UUID) -> Bool
}
