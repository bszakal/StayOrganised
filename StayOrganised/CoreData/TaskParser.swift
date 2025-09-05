import Foundation
import CoreData

class TaskParser: TaskParserProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func convertToBusinessModel(_ entity: TaskEntity) -> Task? {
        guard let id = entity.id,
              let title = entity.title,
              let createdAt = entity.createdAt,
              let updatedAt = entity.updatedAt else {
            return nil
        }
        
        let category = TaskCategory(rawValue: entity.category ?? "personal") ?? .personal
        let priority = TaskPriority(rawValue: entity.priority) ?? .medium
        let taskType = TaskType(rawValue: entity.taskType ?? "individual") ?? .individual
        
        return Task(
            id: id,
            title: title,
            taskDescription: entity.taskDescription,
            category: category,
            priority: priority,
            taskType: taskType,
            dueDate: entity.dueDate ?? Date(),
            isCompleted: entity.isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    func convertToCoreDataModel(_ task: Task) -> TaskEntity? {
        let entity = TaskEntity(context: context)
        updateCoreDataModel(entity, with: task)
        return entity
    }
    
    func updateCoreDataModel(_ entity: TaskEntity, with task: Task) {
        entity.id = task.id
        entity.title = task.title
        entity.taskDescription = task.taskDescription
        entity.category = task.category.rawValue
        entity.priority = task.priority.rawValue
        entity.taskType = task.taskType.rawValue
        entity.dueDate = task.dueDate
        entity.isCompleted = task.isCompleted
        entity.createdAt = task.createdAt
        entity.updatedAt = task.updatedAt
    }
}
