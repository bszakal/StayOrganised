import SwiftUI

struct CalendarDayView: View {
    
    let day: Date
    let tasksInfo: (completed: Int, total: Int)
    let theme: AppTheme
    let isInDateRange: Bool
    let month: Date
    let onTap: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(day)
    }
    
    private var isInCurrentMonth: Bool {
        Calendar.current.compare(day, to: month, toGranularity: .month) == .orderedSame
    }
    
    private var completionPercentage: Double {
        guard tasksInfo.total > 0 else { return 0 }
        return Double(tasksInfo.completed) / Double(tasksInfo.total)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: day))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                if tasksInfo.total > 0 {
                    Text("\(Int(completionPercentage * 100))%")
                        .font(.caption2)
                        .foregroundColor(theme.primaryColor)
                }
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isInDateRange ? 2 : 0)
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isToday {
            return .white
        } else if isInCurrentMonth {
            return theme.textPrimaryColor
        } else {
            return theme.textSecondaryColor.opacity(0.5)
        }
    }
    
    private var backgroundColor: Color {
        if tasksInfo.total > 0 {
            return theme.primaryColor.opacity(completionPercentage * 0.3)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return theme.primaryColor
    }
}
