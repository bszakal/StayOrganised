import Foundation
import CoreData

class CoreDataService: CoreDataServiceProtocol {
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private var context: NSManagedObjectContext
    
    func fetchTasks(startDate: Date, endDate: Date) -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        // Normalize to NSDates for Core Data
           let startOfDay = Calendar.current.startOfDay(for: startDate) as NSDate
           let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)! as NSDate
        request.predicate = NSPredicate(format: "(dueDate >= %@) AND (dueDate <= %@)", startOfDay, endOfDay)
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: true)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func fetchTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: true)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    
    func fetchTask(id: UUID) throws -> TaskEntity {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(request)
            guard let task = tasks.first else {
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            return task
        }
    }
    
    func createTask(_ task: TaskEntity) -> Bool {
        context.insert(task)
        return saveContext()
    }
    
    func updateTask(_ task: TaskEntity) -> Bool {
        task.updatedAt = Date()
        return saveContext()
    }
    
    func deleteTask(_ task: TaskEntity) -> Bool {
        context.delete(task)
        return saveContext()
    }
    
    func deleteTask(withId id: UUID) -> Bool {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try context.fetch(request)
            if let taskToDelete = tasks.first {
                context.delete(taskToDelete)
                return saveContext()
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
        return false
    }
    
    func saveContext() -> Bool {
        guard context.hasChanges else { return true }
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save context: \(error)")
            return false
        }
    }
}
