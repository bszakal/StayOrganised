import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: MainTabViewModel
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel.homeViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text(LocalizedString.home.localized)
                }
            
            CalendarView(viewModel: viewModel.calendarViewModel)
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
