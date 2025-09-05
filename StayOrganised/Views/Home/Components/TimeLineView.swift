//
//  TimeLineView.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 05/09/2025.
//

import SwiftUI

struct TimeLineView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: TimeLineViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedString.yourTimeline.localized)
                .font(.subheadline)
                .foregroundColor(themeManager.currentTheme.textSecondaryColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.weekDays, id: \.self) { day in
                        DayCardView(
                            day: day,
                            isSelected: Calendar.current.isDate(day, inSameDayAs: viewModel.selectedDate),
                            theme: themeManager.currentTheme
                        ) {
                            viewModel.selectDate(day)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
