import Foundation

class CreateTaskViewModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var taskDescription = ""
    @Published var dueDate = Date()
    @Published var selectedCategory: TaskCategory = .personal
    @Published var selectedPriority: TaskPriority = .medium
    
    private let taskToModify: Task?
    
    public let id = UUID()
    private let coreDataManager: CoreDataManagerProtocol
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var titleView: String {
        if taskToModify != nil {
            LocalizedString.modifyTask.localized
        } else {
            LocalizedString.createTask.localized
        }
    }
    
    var isModifyMode: Bool {
        taskToModify != nil
    }
    
    init(coreDataManager: CoreDataManagerProtocol, task: Task?) {
        self.coreDataManager = coreDataManager
        
        guard let task else {
            self.taskToModify = nil
            return
        }
        
        self.title = task.title
        self.taskDescription = task.taskDescription ?? ""
        self.dueDate = task.dueDate
        self.selectedCategory = task.category
        self.selectedPriority = task.priority
        self.taskToModify = task
    }
    
    func createTask() {
        guard isFormValid else { return }
        
        let task = Task(
            id: self.taskToModify?.id ?? UUID(),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: taskDescription.isEmpty ? nil : taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            priority: selectedPriority,
            taskType: .individual,
            dueDate: dueDate
        )
        
        if self.taskToModify != nil {
            _ = coreDataManager.updateTask(task)
            
        } else {
            _ = coreDataManager.createTask(task)
        }
        resetForm()
    }
    
    func deleteTask() {
        guard let taskToModify = taskToModify else { return }
        _ = coreDataManager.deleteTask(taskToModify)
    }
    
    private func resetForm() {
        title = ""
        taskDescription = ""
        dueDate = Date()
        selectedCategory = .personal
        selectedPriority = .medium
    }
}
