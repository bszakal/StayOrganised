import SwiftUI

struct CategoryChipView: View {
    
    let category: TaskCategory
    let isSelected: Bool
    let theme: AppTheme
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: category.iconName)
                    .font(.caption)
                
                Text(category.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? theme.primaryColor : theme.cardBackgroundColor)
            )
            .foregroundColor(isSelected ? .white : theme.textPrimaryColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
}