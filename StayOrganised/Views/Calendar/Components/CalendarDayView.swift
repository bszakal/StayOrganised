import SwiftUI

struct CalendarDayView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: CalendarDayViewModel
    
    var body: some View {
        Button(action: viewModel.onTap) {
            VStack(spacing: 4) {
                Text(viewModel.dayFormatter.string(from: viewModel.day))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(textColor)
                
                if viewModel.tasksInfo.total > 0 {
                    Text("\(Int(viewModel.completionPercentage * 100))%")
                        .font(.caption2)
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                }
            }
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: viewModel.isInDateRange ? 2 : 0)
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if viewModel.isToday {
            return .white
        } else if viewModel.isInCurrentMonth {
            return themeManager.currentTheme.textPrimaryColor
        } else {
            return themeManager.currentTheme.textSecondaryColor.opacity(0.5)
        }
    }
    
    private var backgroundColor: Color {
        if viewModel.tasksInfo.total > 0 {
            return themeManager.currentTheme.primaryColor.opacity(viewModel.completionPercentage * 0.3)
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        return themeManager.currentTheme.primaryColor
    }
}
