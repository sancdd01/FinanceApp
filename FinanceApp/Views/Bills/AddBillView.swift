//
//  AddBillView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/22/26.
//

import SwiftUI
import SwiftData

struct AddBillView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var amount = ""
    @State private var dayOfMonth = Calendar.current.component(.day, from: Date())
    @State private var category = ""
    @State private var isAutopay = false
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Stepper("Day of Month: \(dayOfMonth)", value: $dayOfMonth, in: 1...31)
                }
                Section("Optional") {
                    TextField("Category", text: $category)
                    Toggle("Autopay", isOn: $isAutopay)
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Add Bill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.isEmpty || Double(amount) == nil)
                }
            }
        }
    }

    private func save() {
        let bill = Bill(
            name: name,
            amount: Double(amount)!,
            dayOfMonth: dayOfMonth,
            category: category.isEmpty ? nil : category,
            isAutopay: isAutopay,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(bill)
        dismiss()
    }
}
