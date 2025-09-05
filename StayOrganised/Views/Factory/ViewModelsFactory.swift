//
//  ViewModelsFactory.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import Foundation

protocol ViewModelsFactoryProtocol: TaskListViewModelFactoryProtocol, HomeViewModelFactoryProtocol, TimeLineViewModelFactoryProtocol, CalendarViewModelFactoryProtocol, CreateTaskViewModelFactoryProtocol {
    
}

protocol TaskListViewModelFactoryProtocol {
    func createTaskListViewModel(startDate: Date?, endDate: Date?) -> TaskListViewModel
}

protocol HomeViewModelFactoryProtocol {
    func createHomeViewModel() -> HomeViewModel
}

protocol TimeLineViewModelFactoryProtocol {
    func createTimeLineViewModel(selectedDate: Date) -> TimeLineViewModel
}

protocol CalendarViewModelFactoryProtocol {
    func createCalendarViewModel() -> CalendarViewModel
}

protocol CreateTaskViewModelFactoryProtocol {
    func createCreateTaskViewModel() -> CreateTaskViewModel
}

class ViewModelsFactory: ViewModelsFactoryProtocol {

    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func createHomeViewModel() -> HomeViewModel {
        return HomeViewModel(coreDataManager: coreDataManager, taskListViewModelFactory: self, timeLineViewModelFactory: self, createTaskViewModelFactory: self)
    }
    
    func createTaskListViewModel(startDate: Date? = Date(), endDate: Date? = nil) -> TaskListViewModel {
        return TaskListViewModel(coreDataManager: coreDataManager, startDate: startDate, endDate: endDate)
    }
    
    func createTimeLineViewModel(selectedDate: Date) -> TimeLineViewModel {
        TimeLineViewModel(selectedDate: selectedDate)
    }
    
    func createCalendarViewModel() -> CalendarViewModel {
        CalendarViewModel(taskListViewModelFactory: self, coreDataManager: coreDataManager)
    }
    
    func createCreateTaskViewModel() -> CreateTaskViewModel {
        CreateTaskViewModel(coreDataManager: coreDataManager)
    }
}
