import Foundation
import CoreData

class CoreDataService: CoreDataServiceProtocol {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StayOrganisedModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        return container
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private var context: NSManagedObjectContext
    
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
