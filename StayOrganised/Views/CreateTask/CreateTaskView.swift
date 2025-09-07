import SwiftUI

struct CreateTaskView: View {
    
    @ObservedObject var viewModel: CreateTaskViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        formContent
                    }
                    .padding()
                }
            }
            .navigationTitle(viewModel.titleView)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                    }
                }
            }
        }
    }
    
    private var formContent: some View {
        VStack(spacing: 20) {
            taskTitle
            taskDescription
            dateAndTime
            category
            prioritySelection
            Spacer(minLength: 40)
            
            if viewModel.isModifyMode {
                deleteButton
            }
            
            saveButton
        }
    }
    
    private var taskTitle: some View {
        ThemedTextField(title: LocalizedString.taskTitle.localized, text: $viewModel.title)
    }
    
    private var taskDescription: some View {
        ThemedTextField(title: LocalizedString.taskActivity.localized, text: $viewModel.taskDescription)
    }
    
    private var dateAndTime: some View {
        HStack(spacing: 16) {
            TitledDatePicker(title: LocalizedString.date.localized, type: .date, date: $viewModel.dueDate)
            TitledDatePicker(title: LocalizedString.time.localized, type: .hourAndMinute, date: $viewModel.dueDate)
        }
    }
    
    private var category: some View {
        DropDownSelection<TaskCategory>(title: LocalizedString.taskCategory.localized,
                                        selections: TaskCategory.allCases.filter { $0 != .all },
                                        selectedItem: $viewModel.selectedCategory)
    }
    

    
    private var prioritySelection: some View {
        DropDownSelection<TaskPriority>(title: LocalizedString.priority.localized,
                                        selections: TaskPriority.allCases,
                                        selectedItem: $viewModel.selectedPriority)
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.createTask()
            dismiss()
        }) {
            Text(LocalizedString.save.localized)
        }
        .buttonStyle(PrimaryButtonStyle(
            backgroundColor: themeManager.currentTheme.primaryColor,
            isDisabled: !viewModel.isFormValid
        ))
        .disabled(!viewModel.isFormValid)
    }
    
    private var deleteButton: some View {
        Button(action: {
            viewModel.deleteTask()
            dismiss()
        }) {
            Text(LocalizedString.delete.localized)
        }
        .buttonStyle(PrimaryButtonStyle(backgroundColor: .red))
    }
}
