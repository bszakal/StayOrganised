import SwiftUI

struct CalendarView: View {
    
    @StateObject private var viewModel = CalendarViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.coreDataManager) private var coreDataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    monthCalendarView
                    dateRangeSelector
                    taskListView
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            if let manager = coreDataManager {
                viewModel.setCoreDataManager(manager)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Calendar")
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
    
    private var dateRangeSelector: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Start Date")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                Text(viewModel.startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not selected")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("End Date")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                Text(viewModel.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not selected")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            }
        }
        .padding()
        .background(themeManager.currentTheme.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.tasksInDateRange) { task in
                    TaskRowView(
                        task: task,
                        theme: themeManager.currentTheme,
                        onTap: { },
                        onToggleComplete: { viewModel.toggleTaskCompletion(task) },
                        onDelete: { viewModel.deleteTask(task) }
                    )
                }
            }
        }
    }
}