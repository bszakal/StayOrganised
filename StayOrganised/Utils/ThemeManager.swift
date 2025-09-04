import SwiftUI

class ThemeManager: ObservableObject {
    
    @Published var currentTheme: AppTheme = .orange
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selected_theme"
    
    init() {
        loadTheme()
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        userDefaults.set(theme.rawValue, forKey: themeKey)
    }
    
    private func loadTheme() {
        let savedTheme = userDefaults.string(forKey: themeKey) ?? AppTheme.orange.rawValue
        currentTheme = AppTheme(rawValue: savedTheme) ?? .orange
    }
}

enum AppTheme: String, CaseIterable {
    case orange = "orange"
    case red = "red"
    case green = "green"
    case blue = "blue"
    case yellow = "yellow"
    
    var primaryColor: Color {
        switch self {
        case .orange: return Color.orange
        case .red: return Color.red
        case .green: return Color.green
        case .blue: return Color.blue
        case .yellow: return Color.yellow
        }
    }
    
    var backgroundColor: Color {
        return Color(red: 0.1, green: 0.1, blue: 0.1)
    }
    
    var cardBackgroundColor: Color {
        return Color(red: 0.15, green: 0.15, blue: 0.15)
    }
    
    var textPrimaryColor: Color {
        return Color.white
    }
    
    var textSecondaryColor: Color {
        return Color.gray
    }
}