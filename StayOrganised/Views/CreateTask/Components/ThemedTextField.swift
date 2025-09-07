//
//  ThemedTextField.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 06/09/2025.
//

import SwiftUI

struct ThemedTextField: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            TextField(LocalizedString.writeHere.localized, text: $text)
                .textFieldStyle(ThemedTextFieldStyle(theme: themeManager.currentTheme))
        }
    }
    
    struct ThemedTextFieldStyle: TextFieldStyle {
        let theme: AppTheme
        
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .background(theme.cardBackgroundColor)
                .cornerRadius(8)
                .foregroundColor(theme.textPrimaryColor)
        }
    }
}
