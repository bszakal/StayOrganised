import SwiftUI

struct ProfileOptionView: View {
    
    let icon: String
    let title: String
    let theme: AppTheme
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(theme.textPrimaryColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(theme.textPrimaryColor)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(theme.textSecondaryColor)
        }
        .padding()
        .background(theme.cardBackgroundColor)
        .cornerRadius(12)
    }
}