import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.coreDataManager) private var coreDataManager
    @State private var showingCreateTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    timelineView
                    progressView
                    categoryFilterView
                    taskListView
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addTaskButton
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if let manager = coreDataManager {
                viewModel.setCoreDataManager(manager)
            }
        }
        .sheet(isPresented: $showingCreateTask) {
            CreateTaskView()
                .environmentObject(themeManager)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedString.goodMorning.localized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            }
            
            Spacer()
        }
    }
    
    private var timelineView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedString.yourTimeline.localized)
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.textSecondaryColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.weekDays, id: \.self) { day in
                        DayCardView(
                            day: day,
                            isSelected: Calendar.current.isDate(day, inSameDayAs: viewModel.selectedDate),
                            theme: themeManager.currentTheme
                        ) {
                            viewModel.selectDate(day)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var progressView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Day 7")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                Spacer()
                
                Text("\(Int(viewModel.completionPercentage))%")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
            }
            
            ProgressView(value: viewModel.completionPercentage / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: themeManager.currentTheme.primaryColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(themeManager.currentTheme.cardBackgroundColor)
        .cornerRadius(12)
    }
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    CategoryChipView(
                        category: category,
                        isSelected: viewModel.selectedCategory == category,
                        theme: themeManager.currentTheme
                    ) {
                        viewModel.selectCategory(category)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var taskListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if !viewModel.pendingTasks.isEmpty {
                    TaskSectionView(
                        title: LocalizedString.todaysTasks.localized,
                        tasks: viewModel.pendingTasks,
                        theme: themeManager.currentTheme,
                        onTaskTap: { task in
                            // Navigate to detail view
                        },
                        onToggleComplete: { task in
                            viewModel.toggleTaskCompletion(task)
                        },
                        onDelete: { task in
                            viewModel.deleteTask(task)
                        }
                    )
                }
                
                if !viewModel.completedTasks.isEmpty {
                    TaskSectionView(
                        title: LocalizedString.completed.localized,
                        tasks: viewModel.completedTasks,
                        theme: themeManager.currentTheme,
                        onTaskTap: { task in
                            // Navigate to detail view
                        },
                        onToggleComplete: { task in
                            viewModel.toggleTaskCompletion(task)
                        },
                        onDelete: { task in
                            viewModel.deleteTask(task)
                        }
                    )
                }
            }
        }
    }
    
    private var addTaskButton: some View {
        Button(action: {
            showingCreateTask = true
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(themeManager.currentTheme.primaryColor)
                .clipShape(Circle())
        }
    }
}
