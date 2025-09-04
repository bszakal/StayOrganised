import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var selectedDate = Date()
    @Published var selectedCategory: TaskCategory = .all
    @Published var completionPercentage: Double = 0
    
    private var coreDataManager: CoreDataManagerProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        let previousDays = (1...3).reversed().compactMap { offset in
            return calendar.date(byAdding: .day, value: -offset, to: today)
        }
        let followingDays = (0...4).compactMap { offset in
            return calendar.date(byAdding: .day, value: offset, to: today)
        }
        
        return previousDays + followingDays
        
    }
    
    var filteredTasks: [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            let matchesDate = calendar.isDate(task.createdAt, inSameDayAs: selectedDate)
            let matchesCategory = selectedCategory == .all || task.category == selectedCategory
            return matchesDate && matchesCategory
        }
    }
    
    var pendingTasks: [Task] {
        filteredTasks.filter { !$0.isCompleted }
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    var completedTasks: [Task] {
        filteredTasks.filter { $0.isCompleted }
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    func setCoreDataManager(_ manager: CoreDataManagerProtocol) {
        self.coreDataManager = manager
        
        manager.tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.tasks = tasks
                self?.updateCompletionPercentage()
            }
            .store(in: &cancellables)
        
        manager.loadTasks()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        updateCompletionPercentage()
    }
    
    func selectCategory(_ category: TaskCategory) {
        selectedCategory = category
        updateCompletionPercentage()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        coreDataManager?.toggleTaskCompletion(task)
    }
    
    func deleteTask(_ task: Task) {
        coreDataManager?.deleteTask(task)
    }
    
    private func updateCompletionPercentage() {
        let totalTasks = filteredTasks.count
        guard totalTasks > 0 else {
            completionPercentage = 0
            return
        }
        
        let completedCount = filteredTasks.filter { $0.isCompleted }.count
        completionPercentage = Double(completedCount) / Double(totalTasks) * 100
    }
}
