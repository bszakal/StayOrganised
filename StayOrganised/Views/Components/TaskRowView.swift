import SwiftUI

struct TaskRowView: View {
    
    let task: Task
    let theme: AppTheme
    let onTap: () -> Void
    let onToggleComplete: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: task.category.iconName)
                    .font(.title3)
                    .foregroundColor(theme.primaryColor)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(theme.textPrimaryColor)
                        .strikethrough(task.isCompleted)
                    
                    if let description = task.taskDescription, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(theme.textSecondaryColor)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Button(action: onToggleComplete) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(task.isCompleted ? theme.primaryColor : theme.textSecondaryColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(theme.cardBackgroundColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(LocalizedString.delete.localized, role: .destructive) {
                onDelete()
            }
            
            Button(LocalizedString.edit.localized) {
                onTap()
            }
            .tint(.blue)
            
            Button(task.isCompleted ? "Mark Undone" : LocalizedString.markAsDone.localized) {
                onToggleComplete()
            }
            .tint(theme.primaryColor)
        }
    }
}