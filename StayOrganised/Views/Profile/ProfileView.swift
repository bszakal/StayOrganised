import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    profileHeaderView
                    settingsListView
                    
                    Spacer()
                    
                    footerView
                }
                .padding()
            }
            .navigationTitle(LocalizedString.profile.localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
            
            Text("Abhijit")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            Text("3 Challenges completed")
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.textSecondaryColor)
        }
    }
    
    private var settingsListView: some View {
        VStack(spacing: 16) {
            NavigationLink(destination: ThemeSelectorView().environmentObject(themeManager)) {
                ProfileOptionView(
                    icon: "paintbrush",
                    title: LocalizedString.changeTheme.localized,
                    theme: themeManager.currentTheme
                )
            }
            
            NavigationLink(destination: LanguageSelectorView().environmentObject(themeManager)) {
                ProfileOptionView(
                    icon: "globe",
                    title: LocalizedString.languagePreferences.localized,
                    theme: themeManager.currentTheme
                )
            }
        }
    }
    
    private var footerView: some View {
        Text(LocalizedString.dareToAchieve.localized)
            .font(.caption)
            .foregroundColor(themeManager.currentTheme.textSecondaryColor)
            .italic()
    }
}