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
            .navigationTitle(LocalizedString.createTask.localized)
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
            saveButton
        }
    }
    
    private var taskTitle: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.taskTitle.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            TextField(LocalizedString.writeHere.localized, text: $viewModel.title)
                .textFieldStyle(ThemedTextFieldStyle(theme: themeManager.currentTheme))
        }
    }
    
    private var taskDescription: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.taskActivity.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            TextField(LocalizedString.writeHere.localized, text: $viewModel.taskDescription)
                .textFieldStyle(ThemedTextFieldStyle(theme: themeManager.currentTheme))
        }
    }
    
    private var dateAndTime: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedString.date.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .background(themeManager.currentTheme.cardBackgroundColor)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedString.time.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                DatePicker("", selection: $viewModel.dueDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .background(themeManager.currentTheme.cardBackgroundColor)
                    .cornerRadius(8)
            }
        }
    }
    
    private var category: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.taskCategory.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            Menu {
                ForEach(TaskCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                    Button(category.displayName) {
                        viewModel.selectedCategory = category
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedCategory.displayName)
                        .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                }
                .padding()
                .background(themeManager.currentTheme.cardBackgroundColor)
                .cornerRadius(8)
            }
        }
    }
    
    private var prioritySelection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.priority.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            Menu {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Button(priority.displayName) {
                        viewModel.selectedPriority = priority
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedPriority.displayName)
                        .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                }
                .padding()
                .background(themeManager.currentTheme.cardBackgroundColor)
                .cornerRadius(8)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.createTask()
            dismiss()
        }) {
            Text(LocalizedString.save.localized)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.currentTheme.primaryColor)
                .cornerRadius(12)
        }
        .disabled(!viewModel.isFormValid)
        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
    }
}

struct ThemedTextFieldStyle: TextFieldStyle {
    let theme: AppTheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(theme.cardBackgroundColor)
            .cornerRadius(8)
            .foregroundColor(theme.textPrimaryColor)
    }
}
