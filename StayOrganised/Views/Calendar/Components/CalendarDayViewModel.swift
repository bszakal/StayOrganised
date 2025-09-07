//
//  CalendarDayViewModel.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 06/09/2025.
//

import Foundation

class CalendarDayViewModel: ObservableObject {
    
    public let day: Date
    public let tasksInfo: (completed: Int, total: Int)
    public let isInDateRange: Bool
    private let month: Date
    public let onTap: () -> Void
    
    public var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    public var isToday: Bool {
        Calendar.current.isDateInToday(day)
    }
    
    public var isInCurrentMonth: Bool {
        Calendar.current.compare(day, to: month, toGranularity: .month) == .orderedSame
    }
    
    public var completionPercentage: Double {
        guard tasksInfo.total > 0 else { return 0 }
        return Double(tasksInfo.completed) / Double(tasksInfo.total)
    }
    
    init(day: Date, tasksInfo: (completed: Int, total: Int), isInDateRange: Bool, month: Date, onTap: @escaping () -> Void) {
        self.day = day
        self.tasksInfo = tasksInfo
        self.isInDateRange = isInDateRange
        self.month = month
        self.onTap = onTap
    }
    
}
