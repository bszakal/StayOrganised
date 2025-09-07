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
    
    private let persistentContainer: NSPersistentContainer
    
    init(coreDataFactory: CoreDataFactoryProtocol) {
        
        self.persistentContainer = coreDataFactory.createPersistentContainer()
        
        self.coreDataService = coreDataFactory.createCoreDataService(context: persistentContainer.viewContext)
        self.taskParser = coreDataFactory.createCoredataParser(context: persistentContainer.viewContext)
        self.loadTasks()
    }
    
    private func loadTasks() {
        let taskEntities = coreDataService.fetchTasks()
        let businessTasks = taskEntities.compactMap { taskParser.convertToBusinessModel($0) }
        tasksSubject.send(businessTasks)
    }

    
//    func fetchTasks(startDate: Date, endDate: Date) -> [Task] {
//        let taskEntities = coreDataService.fetchTasks(startDate: startDate, endDate: endDate)
//        let businessTasks = taskEntities.compactMap { taskParser.convertToBusinessModel($0) }
//        return businessTasks
//    }
    
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
        let taskEntity = try? coreDataService.fetchTask(id: task.id)
        guard let existingEntity = taskEntity else {
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
