//
//  TasksProgressView.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import SwiftUI

struct TasksProgressView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let completionPercentage: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.currentTheme.textPrimaryColor)
                
                Spacer()
                
                Text("\(Int(completionPercentage * 100.0 ))%")
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.textSecondaryColor)
            }
            
            ProgressView(value: completionPercentage)
                .progressViewStyle(LinearProgressViewStyle(tint: themeManager.currentTheme.primaryColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(themeManager.currentTheme.cardBackgroundColor)
        .cornerRadius(12)
    }
}
