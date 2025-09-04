import Foundation
import CoreData
import Combine

class CoreDataManager: CoreDataManagerProtocol {
    
    private let coreDataService: CoreDataServiceProtocol
    private let taskParser: TaskParserProtocol
    
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    var tasks: AnyPublisher<[Task], Never> {
        tasksSubject.eraseToAnyPublisher()
    }
    
    init(coreDataService: CoreDataServiceProtocol, taskParser: TaskParserProtocol) {
        self.coreDataService = coreDataService
        self.taskParser = taskParser
        loadTasks()
    }
    
    func loadTasks() {
        let taskEntities = coreDataService.fetchTasks()
        let businessTasks = taskEntities.compactMap { taskParser.convertToBusinessModel($0) }
        tasksSubject.send(businessTasks)
    }
    
    func createTask(_ task: Task) -> Bool {
        guard let taskEntity = taskParser.convertToCoreDataModel(task) else {
            return false
        }
        
        let success = coreDataService.createTask(taskEntity)
        if success {
            loadTasks()
        }
        return success
    }
    
    func updateTask(_ task: Task) -> Bool {
        let taskEntities = coreDataService.fetchTasks()
        guard let existingEntity = taskEntities.first(where: { $0.id == task.id }) else {
            return false
        }
        
        taskParser.updateCoreDataModel(existingEntity, with: task)
        let success = coreDataService.updateTask(existingEntity)
        if success {
            loadTasks()
        }
        return success
    }
    
    func deleteTask(_ task: Task) -> Bool {
        let success = coreDataService.deleteTask(withId: task.id)
        if success {
            loadTasks()
        }
        return success
    }
    
    func deleteTask(withId id: UUID) -> Bool {
        let success = coreDataService.deleteTask(withId: id)
        if success {
            loadTasks()
        }
        return success
    }
    
    func toggleTaskCompletion(_ task: Task) -> Bool {
        let updatedTask = Task(
            id: task.id,
            title: task.title,
            taskDescription: task.taskDescription,
            category: task.category,
            priority: task.priority,
            taskType: task.taskType,
            dueDate: task.dueDate,
            isCompleted: !task.isCompleted,
            createdAt: task.createdAt,
            updatedAt: Date()
        )
        return updateTask(updatedTask)
    }
}