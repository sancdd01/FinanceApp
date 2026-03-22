//
//  OrganizerHeaderView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/22/26.
//

import SwiftUI

struct OrganizerHeaderView: View {
    @Binding var selectedMonth: Date
    
    private var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedMonth)
    }
    
    var body: some View {
        HStack {
            Button { shiftMonth(-1) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
            }
            Spacer()
            Text(monthLabel)
                .font(.title2).bold()
            Spacer()
            Button { shiftMonth(1) } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal)
    }
    
    private func shiftMonth(_ value: Int) {
        selectedMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? selectedMonth
    }
}
