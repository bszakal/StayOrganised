import Foundation

class CreateTaskViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var taskDescription = ""
    @Published var dueDate = Date()
    @Published var selectedCategory: TaskCategory = .personal
    @Published var selectedPriority: TaskPriority = .medium
    
    private let coreDataManager: CoreDataManagerProtocol
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func createTask() {
        guard isFormValid else { return }
        
        let task = Task(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            taskDescription: taskDescription.isEmpty ? nil : taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            priority: selectedPriority,
            taskType: .individual,
            dueDate: dueDate
        )
        
        _ = coreDataManager.createTask(task)
        resetForm()
    }
    
    private func resetForm() {
        title = ""
        taskDescription = ""
        dueDate = Date()
        selectedCategory = .personal
        selectedPriority = .medium
    }
}
