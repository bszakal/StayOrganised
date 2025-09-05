import SwiftUI

struct LanguageSelectorView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedLanguage = "en"
    @State private var showingRestartAlert = false
    
    private let languages = [
        ("en", "English"),
        ("fr", "Français")
    ]
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ForEach(languages, id: \.0) { languageCode, languageName in
                    Button(action: {
                        selectedLanguage = languageCode
                        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
                        UserDefaults.standard.synchronize()
                        
                        // Show alert to restart app
                        showingRestartAlert = true
                    }) {
                        HStack {
                            Text(languageName)
                                .font(.body)
                                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                            
                            Spacer()
                            
                            if selectedLanguage == languageCode {
                                Image(systemName: "checkmark")
                                    .foregroundColor(themeManager.currentTheme.primaryColor)
                            }
                        }
                        .padding()
                        .background(themeManager.currentTheme.cardBackgroundColor)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(LocalizedString.languagePreferences.localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedLanguage = Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        }
        .alert("Language Changed", isPresented: $showingRestartAlert) {
            Button("OK") { }
        } message: {
            Text("Please restart the app to see the language change take effect.")
        }
    }
}