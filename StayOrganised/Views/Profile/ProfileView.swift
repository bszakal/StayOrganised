import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    settingsListView
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(LocalizedString.profile.localized)
            .navigationBarTitleDisplayMode(.inline)
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
}
