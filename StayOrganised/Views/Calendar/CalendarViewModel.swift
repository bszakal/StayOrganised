import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var selectedMonth = Date()
    @Published var startDate: Date? {
        didSet {
            taskListViewModel.startDate = startDate
        }
    }
    @Published var endDate: Date? {
        didSet {
            taskListViewModel.endDate = endDate
        }
    }
    
    private var coreDataManager: CoreDataManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var taskListViewModel: TaskListViewModel
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    init(taskListViewModelFactory: TaskListViewModelFactoryProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.taskListViewModel = taskListViewModelFactory.createTaskListViewModel(startDate: nil, endDate: nil)
        self.coreDataManager = coreDataManager
        self.subscriptions()
    }
    

    
    var availableMonths: [Date] {
        let calendar = Calendar.current
        let now = Date()
        return (-6...6).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: now)
        }
    }
    
    var daysInMonth: [Date] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth) else {
            return []
        }
        
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startOffset = firstWeekday - 1
        
        guard let startDate = calendar.date(byAdding: .day, value: -startOffset, to: firstDayOfMonth) else {
            return []
        }
        
        return (0..<35).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }
    
    func selectMonth(_ month: Date) {
        selectedMonth = month
    }
    
    func selectDate(_ date: Date) {
        if startDate == nil {
            startDate = date
            endDate = nil
        } else if endDate == nil {
            if date >= startDate! {
                endDate = date
            } else {
                startDate = date
                endDate = nil
            }
        } else {
            startDate = date
            endDate = nil
        }
    }
    
    func isDateInRange(_ date: Date) -> Bool {
        guard let start = startDate else { return false }
        
        if let end = endDate {
            return date >= start && date <= end
        } else {
            return Calendar.current.isDate(date, inSameDayAs: start)
        }
    }
    
    func getTasksInfo(for date: Date) -> (completed: Int, total: Int) {

        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) else { return (0,0) }
        
        let filteredByDateTasks = tasks.filter { task in
            let dateFilter = task.dueDate >= startOfDay && task.dueDate <= endOfDay
            return dateFilter
        }

        let pendingTasks = filteredByDateTasks
                                .filter { !$0.isCompleted }
                                .sorted { $0.createdAt < $1.createdAt }
        
        let completedTasks = filteredByDateTasks
                                .filter { $0.isCompleted }
                                .sorted { $0.createdAt < $1.createdAt }
        
        return (completedTasks.count, pendingTasks.count + completedTasks.count)
    }
    
    private func subscriptions() {
        self.coreDataManager.tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.tasks = tasks
            }
            .store(in: &cancellables)
    }
}
