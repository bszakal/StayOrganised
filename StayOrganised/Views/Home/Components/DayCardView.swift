import SwiftUI

struct DayCardView: View {
    
    let day: Date
    let isSelected: Bool
    let theme: AppTheme
    let onTap: () -> Void
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }
    
    private var dayNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: day).uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : theme.textSecondaryColor)
                
                Text(dayNumberFormatter.string(from: day))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : theme.textPrimaryColor)
            }
            .frame(width: 32, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? theme.primaryColor : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}