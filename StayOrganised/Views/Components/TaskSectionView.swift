import SwiftUI

struct TaskSectionView: View {
    
    let title: String
    let tasks: [Task]
    let theme: AppTheme
    let onTaskTap: (Task) -> Void
    let onToggleComplete: (Task) -> Void
    let onDelete: (Task) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(theme.textPrimaryColor)
            
            ForEach(tasks) { task in
                TaskRowView(
                    task: task,
                    theme: theme,
                    onTap: { onTaskTap(task) },
                    onToggleComplete: { onToggleComplete(task) },
                    onDelete: { onDelete(task) }
                )
            }
        }
    }
}
