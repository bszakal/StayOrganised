import Foundation

class CreateTaskViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var taskDescription = ""
    @Published var dueDate = Date()
    @Published var selectedCategory: TaskCategory = .personal
    @Published var selectedTaskType: TaskType = .individual
    @Published var selectedPriority: TaskPriority = .medium
    
    private var coreDataManager: CoreDataManagerProtocol?
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func setCoreDataManager(_ manager: CoreDataManagerProtocol) {
        self.coreDataManager = manager
    }
    
    func createTask() {
        guard isFormValid else { return }
        
        let task = Task(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: taskDescription.isEmpty ? nil : taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            priority: selectedPriority,
            taskType: selectedTaskType,
            dueDate: dueDate
        )
        
        coreDataManager?.createTask(task)
        resetForm()
    }
    
    private func resetForm() {
        title = ""
        taskDescription = ""
        dueDate = Date()
        selectedCategory = .personal
        selectedTaskType = .individual
        selectedPriority = .medium
    }
}