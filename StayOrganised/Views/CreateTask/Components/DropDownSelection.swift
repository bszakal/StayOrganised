//
//  DropDownSelection.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 06/09/2025.
//

import SwiftUI

struct DropDownSelection<T: Identifiable & DisplayName>: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let title: String
    let selections: [T]
    @Binding var selectedItem: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            Menu {
                ForEach(selections) { item in
                    Button(item.displayName) {
                        selectedItem = item
                    }
                }
            } label: {
                HStack {
                    Text(selectedItem.displayName)
                        .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                }
                .padding()
                .background(themeManager.currentTheme.cardBackgroundColor)
                .cornerRadius(8)
            }
        }
    }
}
