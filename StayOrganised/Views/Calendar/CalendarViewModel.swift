import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var selectedMonth = Date()
    @Published var startDate: Date?
    @Published var endDate: Date?
    
    private var coreDataManager: CoreDataManagerProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
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
        
        return (0..<42).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }
    
    var tasksInDateRange: [Task] {
        guard let start = startDate, let end = endDate else {
            return []
        }
        
        return tasks.filter { task in
            let taskDate = Calendar.current.startOfDay(for: task.createdAt)
            let startDay = Calendar.current.startOfDay(for: start)
            let endDay = Calendar.current.startOfDay(for: end)
            return taskDate >= startDay && taskDate <= endDay
        }
        .sorted { first, second in
            if first.isCompleted != second.isCompleted {
                return !first.isCompleted
            }
            return first.createdAt < second.createdAt
        }
    }
    
    func setCoreDataManager(_ manager: CoreDataManagerProtocol) {
        self.coreDataManager = manager
        
        manager.tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.tasks = tasks
            }
            .store(in: &cancellables)
        
        manager.loadTasks()
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
        let calendar = Calendar.current
        let dayTasks = tasks.filter { calendar.isDate($0.createdAt, inSameDayAs: date) }
        let completedCount = dayTasks.filter { $0.isCompleted }.count
        return (completed: completedCount, total: dayTasks.count)
    }
    
    func toggleTaskCompletion(_ task: Task) {
        coreDataManager?.toggleTaskCompletion(task)
    }
    
    func deleteTask(_ task: Task) {
        coreDataManager?.deleteTask(task)
    }
}