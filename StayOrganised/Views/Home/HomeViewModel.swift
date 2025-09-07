import Foundation
import Combine

class HomeViewModel: ObservableObject {
        
    @Published var selectedDate : Date {
        didSet {
            taskListViewModel.startDate = selectedDate
            taskListViewModel.endDate = selectedDate
        }
    }
    
    @Published var selectedCategory: TaskCategory = .all {
        didSet {
            taskListViewModel.category = selectedCategory
        }
    }
    
    @Published var completionPercentage: Double = 0
    
    private var coreDataManager: CoreDataManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    public let taskListViewModel: TaskListViewModel
    public let timeLineViewModel: TimeLineViewModel
    private let createTaskViewModelFactory: CreateTaskViewModelFactoryProtocol
    
    init(coreDataManager: CoreDataManagerProtocol,
         taskListViewModelFactory: TaskListViewModelFactoryProtocol,
         timeLineViewModelFactory: TimeLineViewModelFactoryProtocol,
         createTaskViewModelFactory: CreateTaskViewModelFactoryProtocol) {
        self.coreDataManager = coreDataManager
        let date = Date()
        self.selectedDate = date
        
        self.taskListViewModel = taskListViewModelFactory.createTaskListViewModel(startDate: Date(), endDate: nil)
        self.timeLineViewModel = timeLineViewModelFactory.createTimeLineViewModel(selectedDate: date)
        self.createTaskViewModelFactory = createTaskViewModelFactory
            
        taskListViewModel.completedTasksCallback = { [weak self] percentage in
            self?.completionPercentage = percentage
        }
        
        timeLineViewModel.selectedDayCallback = { [weak self] date in
            self?.selectedDate = date
        } 
    }
    
    func selectCategory(_ category: TaskCategory) {
        selectedCategory = category
    }
    
    public func generateCreateTaskViewModel(task: Task?) -> CreateTaskViewModel {
        return createTaskViewModelFactory.createCreateTaskViewModel(task: task)
    }
}
