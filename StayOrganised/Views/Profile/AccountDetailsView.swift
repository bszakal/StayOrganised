import SwiftUI

struct AccountDetailsView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                Text("Account Details")
                    .font(.title)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(LocalizedString.accountDetails.localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChallengeStatisticsView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                Text("Challenge Statistics")
                    .font(.title)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(LocalizedString.challengeStatistics.localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactSupportView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                Text("Contact Support")
                    .font(.title)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(LocalizedString.contactSupport.localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}