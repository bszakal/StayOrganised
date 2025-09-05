//
//  MainTabViewModel.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 04/09/2025.
//

import Foundation

class MainTabViewModel: ObservableObject {
    
    public let homeViewModel: HomeViewModel
    public let calendarViewModel: CalendarViewModel
    
    init(homeViewModelFactory: HomeViewModelFactoryProtocol, calendarViewModelFactory: CalendarViewModelFactoryProtocol) {
        self.homeViewModel = homeViewModelFactory.createHomeViewModel()
        self.calendarViewModel = calendarViewModelFactory.createCalendarViewModel()
    }
}
