import SwiftUI

struct ThemeSelectorView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text(LocalizedString.chooseTheme.localized)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                HStack(spacing: 16) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button(action: {
                            themeManager.setTheme(theme)
                        }) {
                            Circle()
                                .fill(theme.primaryColor)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: themeManager.currentTheme == theme ? 3 : 0)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(LocalizedString.changeTheme.localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}