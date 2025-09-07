//
//  TaskListViewModel.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import SwiftUI
import Combine

class TaskListViewModel: ObservableObject {
    
    private var tasks: [Task] = []
    @Published var pendingTasks = [Task]()
    @Published var completedTasks = [Task]()
    @Published var createTaskViewModel: CreateTaskViewModel?
    
    private var coreDataManager: CoreDataManagerProtocol
    private var createTaskViewModelFactory: CreateTaskViewModelFactoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    public var startDate: Date? {
        didSet {
            self.applyFilters(tasks: tasks)
        }
    }
    public var endDate: Date? {
        didSet {
            self.applyFilters(tasks: tasks)
        }
    }
    
    public var category: TaskCategory {
        didSet {
            self.applyFilters(tasks: tasks)
        }
    }
    
    public var completedTasksCallback: ((Double) -> Void)?
    
    init(coreDataManager: CoreDataManagerProtocol,
         createTaskViewModelFactory: CreateTaskViewModelFactoryProtocol,
         startDate: Date? = Date(),
         endDate: Date? = nil,
         category: TaskCategory = .all) {
        self.coreDataManager = coreDataManager
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        self.createTaskViewModelFactory = createTaskViewModelFactory
        self.subscriptions()
    }
    
    func createTaskRowViewModel(task: Task) -> TaskRowViewModel {
        let onTapCompletion: (Task) -> Void = { [weak self] task in
            self?.createTaskViewModel(task: task)
        }
        
        let onToggleComplete: (Task) -> Void = { [weak self] task in
            self?.toggleTaskCompletion(task)
        }
        
        let onDelete: (Task) -> Void = { [weak self] task in
            self?.deleteTask(task)
        }
        
        return TaskRowViewModel(task: task, onTapCompletion: onTapCompletion, onToggleComplete: onToggleComplete, onDelete: onDelete)
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        _ = coreDataManager.toggleTaskCompletion(task)
    }
    
    private func deleteTask(_ task: Task) {
        _ = coreDataManager.deleteTask(task)
    }
    
    private func createTaskViewModel(task: Task) {
        self.createTaskViewModel = self.createTaskViewModelFactory.createCreateTaskViewModel(task: task)
    }

    private func subscriptions() {
        self.coreDataManager.tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.tasks = tasks
                self?.applyFilters(tasks: tasks)
            }
            .store(in: &self.cancellables)
    }
    
    private func applyFilters(tasks: [Task]) {
        guard let startDate, let endDate = self.endDate ?? self.startDate else {
            return
        }
        let startOfDay = Calendar.current.startOfDay(for: startDate)
        guard let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) else { return }
        
        let filteredByDateTasks = tasks.filter { task in
            let dateFilter = task.dueDate >= startOfDay && task.dueDate <= endOfDay
            let categoryFilter = self.category == .all ? true : task.category == self.category
            return dateFilter && categoryFilter
        }

        self.pendingTasks = filteredByDateTasks
                                .filter { !$0.isCompleted }
                                .sorted { $0.createdAt < $1.createdAt }
        
        self.completedTasks = filteredByDateTasks
                                .filter { $0.isCompleted }
                                .sorted { $0.createdAt < $1.createdAt }
        
        guard filteredByDateTasks.isEmpty == false else {
            completedTasksCallback?(0)
            return
        }
        completedTasksCallback?(Double(completedTasks.count)/Double(filteredByDateTasks.count))
        
    }
    
}
