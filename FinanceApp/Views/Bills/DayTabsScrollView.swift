//
//  DayTabsScrollView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/22/26.
//

import SwiftUI

struct DayTabsScrollView: View {
    @Binding var selectedDay: Int
    let bills: [Bill]
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(1...31, id: \.self) { day in
                        DayTabView(
                            day: day,
                            isSelected: selectedDay == day,
                            dotColor: dotColor(for: day)
                        )
                        .id(day)
                        .onTapGesture { selectedDay = day }
                    }
                }
                .padding(.horizontal)
            }
    }
    
    private func dotColor(for day: Int) -> Color? {
        let dayBills = bills.filter { $0.dayOfMonth == day}
        if dayBills.isEmpty { return nil }
        if dayBills.contains(where: { $0.status == .overdue }) { return .red }
        if dayBills.contains(where: { $0.status == .dueToday }) { return .orange }
        if dayBills.allSatisfy({ $0.status == .paid }) { return .green }
        return .orange
    }
}

private struct DayTabView: View {
    let day: Int
    let isSelected: Bool
    let dotColor: Color?
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(day)")
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.primary : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Circle()
                .fill(dotColor ?? .clear)
                .frame(width: 6, height: 6)
        }
        .accessibilityLabel("Day \(day)\(dotColor != nil ? ", bills due" : "")\(isSelected ? ", selected" : "")")
    }
}
