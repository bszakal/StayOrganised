//
//  ViewModelsFactory.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import Foundation

protocol ViewModelsFactoryProtocol: TaskListViewModelFactoryProtocol, HomeViewModelFactoryProtocol, TimeLineViewModelFactoryProtocol, CalendarViewModelFactoryProtocol, CreateTaskViewModelFactoryProtocol, CalendarDayViewModelFactoryProtocol {
    
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
    func createCreateTaskViewModel(task: Task?) -> CreateTaskViewModel
}

protocol CalendarDayViewModelFactoryProtocol {
    func createCalendarDayViewModel(day: Date,
                                    tasksInfo: (completed: Int, total: Int),
                                    isInDateRange: Bool,
                                    month: Date,
                                    onTap: @escaping () -> Void) -> CalendarDayViewModel
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
        return TaskListViewModel(coreDataManager: coreDataManager, createTaskViewModelFactory: self, startDate: startDate, endDate: endDate)
    }
    
    func createTimeLineViewModel(selectedDate: Date) -> TimeLineViewModel {
        TimeLineViewModel(selectedDate: selectedDate)
    }
    
    func createCalendarViewModel() -> CalendarViewModel {
        CalendarViewModel(taskListViewModelFactory: self, coreDataManager: coreDataManager, calendarDayViewModelFactory: self)
    }
    
    func createCreateTaskViewModel(task: Task? = nil) -> CreateTaskViewModel {
        CreateTaskViewModel(coreDataManager: coreDataManager, task: task)
    }
    
    func createCalendarDayViewModel(day: Date,
                                    tasksInfo: (completed: Int, total: Int),
                                    isInDateRange: Bool,
                                    month: Date,
                                    onTap: @escaping () -> Void) -> CalendarDayViewModel {
        CalendarDayViewModel(day: day, tasksInfo: tasksInfo, isInDateRange: isInDateRange, month: month, onTap: onTap)
    }
}
