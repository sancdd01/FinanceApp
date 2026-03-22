//
//  BillOrganizerView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/22/26.
//

import SwiftUI
import SwiftData

struct BillOrganizerView: View {
    @Query private var bills: [Bill]
    
    @State private var selectedMonth: Date = Date()
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    private var selectedDateLabel: String {
        var components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
        components.day = selectedDay
        let date = Calendar.current.date(from: components) ?? selectedMonth
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private var billsForSelectedDay: [Bill] {
        bills.filter { $0.dayOfMonth == selectedDay }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                OrganizerHeaderView(selectedMonth: $selectedMonth)
                    .padding(.top, 8)
                
                DayTabsScrollView(selectedDay: $selectedDay, bills: bills)
                    .padding(.vertical, 12)
                
                // Summary
                VStack(spacing: 4) {
                    Text(selectedDateLabel)
                        .font(.headline)
                    if billsForSelectedDay.isEmpty {
                        Text("No Bills")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(billsForSelectedDay.count) bill\(billsForSelectedDay.count == 1 ? "" : "s") . \(String(format: "$%.2f", billsForSelectedDay.reduce(0) { $0 + $1.amount }))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 12)
                
                Divider()
                
                // Bills or empty state
                if billsForSelectedDay.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No bills due on \(selectedDateLabel)")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(billsForSelectedDay) { bill in
                                Text(bill.name) // placeholder - replaced in Task 5
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Bills")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BillOrganizerView()
        .modelContainer(for: Bill.self, inMemory: true)
}
