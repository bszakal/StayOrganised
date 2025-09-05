//
//  DateRangeSelector.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import SwiftUI

struct DateRangeSelector: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    let startDate: Date?
    let endDate: Date?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Start Date")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                Text(startDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not selected")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("End Date")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
                Text(endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Not selected")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
            }
        }
        .padding()
        .background(themeManager.currentTheme.cardBackgroundColor)
        .cornerRadius(12)
    }
}
