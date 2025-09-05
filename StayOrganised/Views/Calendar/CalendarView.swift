import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel: CalendarViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    monthCalendarView
                    DateRangeSelector(startDate: viewModel.startDate, endDate: viewModel.endDate)
                    TaskListView(viewModel: viewModel.taskListViewModel)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(LocalizedString.calendar.localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            Spacer()
            
            Menu {
                ForEach(viewModel.availableMonths, id: \.self) { month in
                    Button(viewModel.monthFormatter.string(from: month)) {
                        viewModel.selectMonth(month)
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.monthFormatter.string(from: viewModel.selectedMonth))
                        .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                    Image(systemName: "chevron.down")
                        .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                }
            }
        }
    }
    
    private var monthCalendarView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(viewModel.daysInMonth, id: \.self) { day in
                CalendarDayView(
                    day: day,
                    tasksInfo: viewModel.getTasksInfo(for: day),
                    theme: themeManager.currentTheme,
                    isInDateRange: viewModel.isDateInRange(day),
                    month: viewModel.selectedMonth,
                    onTap: {
                        viewModel.selectDate(day)
                    }
                )
            }
        }
        .padding()
        .background(themeManager.currentTheme.cardBackgroundColor)
        .cornerRadius(16)
    }
}
