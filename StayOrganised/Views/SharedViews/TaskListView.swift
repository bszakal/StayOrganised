//
//  TaskListView.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 04/09/2025.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        List {
            Section(LocalizedString.todaysTasks.localized) {
                ForEach(viewModel.pendingTasks) { task in
                    TaskRowView(viewModel: viewModel.createTaskRowViewModel(task: task))
                }
            }
            
            Section(LocalizedString.completed.localized) {
                ForEach(viewModel.completedTasks) { task in
                    TaskRowView(viewModel: viewModel.createTaskRowViewModel(task: task))
                }
            }
        }
        .sheet(item: $viewModel.createTaskViewModel) { viewModel in
            CreateTaskView(viewModel: viewModel)
        }
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.backgroundColor)
        .listStyle(.grouped)
    }
}
