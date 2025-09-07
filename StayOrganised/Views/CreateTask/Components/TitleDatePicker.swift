//
//  TitleDatePicker.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 06/09/2025.
//

import SwiftUI

struct TitledDatePicker: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let title: String
    let type: DatePickerComponents
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedString.time.localized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            
            DatePicker("", selection: $date, displayedComponents: type)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .background(themeManager.currentTheme.cardBackgroundColor)
                .cornerRadius(8)
        }
    }
}
