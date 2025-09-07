import SwiftUI

struct TaskRowView: View {
    let viewModel: TaskRowViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
            HStack(spacing: 12) {
                image
                VStack(alignment: .leading, spacing: 4) {
                    title
                    description
                }
                Spacer()
                toggleButton
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.onTap()
            }
            .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            swipeActionsButtons
        }
    }
    
    private var image: some View {
        Image(systemName: viewModel.task.category.iconName)
            .font(.title3)
            .foregroundColor(themeManager.currentTheme.primaryColor)
            .frame(width: 24, height: 24)
    }
    
    private var title: some View {
        Text(viewModel.task.title)
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            .strikethrough(viewModel.task.isCompleted)
    }
    
   @ViewBuilder private var description: some View {
       if let description = viewModel.task.taskDescription, !description.isEmpty {
            Text(description)
                .font(.caption)
                .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                .lineLimit(1)
        }
    }
    
    private var toggleButton: some View {
        Button(action: viewModel.onToggle) {
            Image(systemName: viewModel.task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(viewModel.task.isCompleted ? themeManager.currentTheme.primaryColor : themeManager.currentTheme.textSecondaryColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
  @ViewBuilder  private var swipeActionsButtons: some View {
        Button(LocalizedString.delete.localized, role: .destructive) {
            viewModel.onDelete()
        }
        
        Button(LocalizedString.edit.localized) {
            viewModel.onTap()
        }
        .tint(Color.brown)
        
      Button(viewModel.task.isCompleted ? LocalizedString.markAsUndone.localized : LocalizedString.markAsDone.localized) {
            viewModel.onToggle()
        }
      .tint(themeManager.currentTheme.primaryColor)
    }
}
