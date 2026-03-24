//
//  BillCardView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/23/26.
//

import SwiftUI
import SwiftData

struct BillCardView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    let bill: Bill
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(bill.name).font(.headline)
                HStack(spacing: 6) {
                    StatusBadge(status: bill.status)
                    if bill.isAutopay {
                        Text("Autopay")
                            .font(.caption2)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.teal.opacity(0.15))
                            .foregroundStyle(.teal)
                            .clipShape(Capsule())
                            
                    }
                }
            }
            Spacer()
            Text(String(format: "$%.2f", bill.amount))
                .font(.headline)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        .swipeActions(edge: .leading) {
            Button {
                withAnimation { bill.status = .paid }
            } label: {
                Label("Paid", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                modelContext.delete(bill)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

private struct StatusBadge: View {
    let status: BillStatus
    
    var body: some View {
        Text(label)
            .font(.caption2)
            .padding(.horizontal, 6).padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
            
    }
    
    private var label: String {
        switch status {
        case .upcoming: return "Upcoming"
        case .dueToday: return "Due Today"
        case .overdue: return "Overdue"
        case .paid: return "Paid"
        }
    }
    
    private var color: Color {
        switch status {
        case .upcoming: return .blue
        case .dueToday: return .orange
        case .overdue: return .red
        case .paid: return .green
        }
    }
}
