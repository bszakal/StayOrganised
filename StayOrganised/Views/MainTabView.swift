import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text(LocalizedString.home.localized)
                }
            
            CalendarView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text(LocalizedString.track.localized)
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text(LocalizedString.profile.localized)
                }
        }
        .accentColor(themeManager.currentTheme.primaryColor)
        .preferredColorScheme(.dark)
    }
}