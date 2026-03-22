//
//  AddDebtView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/21/26.
//

import SwiftUI
import SwiftData

struct AddDebtView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var creditorName = ""
    @State private var balance = ""
    @State private var interestRate = ""
    @State private var minimumPayment = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Creditor Name", text: $creditorName)
                TextField("Balance", text: $balance)
                    .keyboardType(.decimalPad)
                TextField("Interest Rate (%)", text: $interestRate)
                    .keyboardType(.decimalPad)
                TextField("Minimum Payment", text: $minimumPayment)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Debt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !creditorName.isEmpty &&
        Double(balance) != nil &&
        Double(interestRate) != nil &&
        Double(minimumPayment) != nil
    }
    
    private func save() {
        let debt  = Debt(
            creditorName: creditorName,
            balance: Double(balance)!,
            interestRate: Double(interestRate)!,
            minimumPayment: Double(minimumPayment)!
        )
        modelContext.insert(debt)
        dismiss()
    }
}
