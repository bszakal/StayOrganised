import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var themeManager: ThemeManager
//    @Environment(\.coreDataManager) private var coreDataManager
    @State private var showingCreateTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    headerView
                    TimeLineView(viewModel: viewModel.timeLineViewModel)
                    TasksProgressView(completionPercentage: viewModel.completionPercentage)
                    categoryFilterView
                    TaskListView(viewModel: viewModel.taskListViewModel)
                    
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
        .sheet(isPresented: $showingCreateTask) {
            CreateTaskView(viewModel: viewModel.generateCreateTaskViewModel())
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
