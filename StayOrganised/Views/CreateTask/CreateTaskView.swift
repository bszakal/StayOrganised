import SwiftUI

struct CreateTaskView: View {
    
    @StateObject private var viewModel = CreateTaskViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.coreDataManager) private var coreDataManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        formContent
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            if let manager = coreDataManager {
                viewModel.setCoreDataManager(manager)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(LocalizedString.createTask.localized)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Spacer()
            
            // Invisible spacer for centering
            Image(systemName: "chevron.left")
                .font(.title2)
                .opacity(0)
        }
    }
    
    private var formContent: some View {
        VStack(spacing: 20) {
            // Task Title
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedString.taskTitle.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                TextField("Write here", text: $viewModel.title)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Task Description
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedString.taskActivity.localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                TextField("Write here", text: $viewModel.taskDescription)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Date and Time
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.date.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.time.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    DatePicker("", selection: $viewModel.dueDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }
            }
            
            // Category and Type
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.taskCategory.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Menu {
                        ForEach(TaskCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                            Button(category.displayName) {
                                viewModel.selectedCategory = category
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedCategory.displayName)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.taskType.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Menu {
                        ForEach(TaskType.allCases, id: \.self) { type in
                            Button(type.displayName) {
                                viewModel.selectedTaskType = type
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedTaskType.displayName)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            
            // Members (if team task)
            if viewModel.selectedTaskType == .team {
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedString.members.localized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    HStack {
                        Text("Mark")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(16)
                            .foregroundColor(.black)
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            Spacer(minLength: 40)
            
            // Create Button
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
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.black)
    }
}