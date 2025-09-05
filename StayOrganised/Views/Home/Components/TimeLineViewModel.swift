//
//  TimeLineViewModel.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import Foundation

class TimeLineViewModel: ObservableObject {
    
    @Published var selectedDate: Date
    public let weekDays: [Date]
    
    public var selectedDayCallback: ((Date) -> Void)?
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        
        self.weekDays = {
            let calendar = Calendar.current
            let today = Date()
            
            let previousDays = (1...3).reversed().compactMap { offset in
                return calendar.date(byAdding: .day, value: -offset, to: today)
            }
            let followingDays = (0...3).compactMap { offset in
                return calendar.date(byAdding: .day, value: offset, to: today)
            }
            
            return previousDays + followingDays
            
        }()
    }
    
    func selectDate(_ date: Date) {
        self.selectedDate = date
        selectedDayCallback?(date)
    }
}
