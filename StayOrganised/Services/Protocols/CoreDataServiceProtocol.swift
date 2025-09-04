import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetchTasks() -> [TaskEntity]
    func createTask(_ task: TaskEntity) -> Bool
    func updateTask(_ task: TaskEntity) -> Bool
    func deleteTask(_ task: TaskEntity) -> Bool
    func deleteTask(withId id: UUID) -> Bool
    func saveContext() -> Bool
}