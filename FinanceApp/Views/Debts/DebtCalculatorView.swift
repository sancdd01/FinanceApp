//
//  DebtCalculatorView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/21/26.
//

import SwiftUI
import SwiftData

enum CalculationStrategy {
    case avalanche, snowball
}

struct DebtCalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var debts: [Debt]
    
    @State private var extraPayment = ""
    @State private var strategy: CalculationStrategy = .avalanche
    @State private var result: PaymentScheduleResult?
    @State private var showingAddDebt = false
    
    private let calculator = DebtCalculator()
    
    var body: some View {
        NavigationStack {
            List {
                // Debts section
                Section("Your Debts") {
                    ForEach(debts) { debt in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(debt.creditorName).font(.headline)
                            Text("Balance: $\(debt.balance, specifier: "%.2f") · \(debt.interestRate, specifier: "%.1f")% APR")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteDebts)
                }
                
                // Calculator inputs
                                Section("Payment Strategy") {
                                    Picker("Strategy", selection: $strategy) {
                                        Text("Avalanche").tag(CalculationStrategy.avalanche)
                                        Text("Snowball").tag(CalculationStrategy.snowball)
                                    }
                                    .pickerStyle(.segmented)

                                    HStack {
                                        Text("Extra Monthly Payment")
                                        Spacer()
                                        TextField("$0.00", text: $extraPayment)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.trailing)
                                    }

                                    Button("Calculate") { calculate() }
                                        .disabled(debts.isEmpty)
                                }

                                // Results
                                if let result {
                                    Section("Results") {
                                        LabeledContent("Months to Payoff", value: "\(result.payoffTimeMonths)")
                                        LabeledContent("Total Interest", value: String(format: "$%.2f", result.totalInterestPaid))
                                        LabeledContent("Total Paid", value: String(format: "$%.2f", result.totalAmountPaid))
                                    }

                                    Section("Payment Schedule") {
                                        ForEach(result.schedule, id: \.month) { month in
                                            DisclosureGroup(month.month) {
                                                ForEach(month.payments, id: \.debtId) { payment in
                                                    if payment.amount > 0, let debt = debts.first(where: { $0.id == payment.debtId }) {
                                                        HStack {
                                                            Text(debt.creditorName).font(.caption)
                                                            Spacer()
                                                            Text("$\(payment.amount, specifier: "%.2f")").font(.caption)
                                                            Text("→ $\(payment.remainingBalance, specifier: "%.2f")").font(.caption).foregroundStyle(.secondary)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .navigationTitle("Debt Calculator")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button { showingAddDebt = true } label: {
                                        Image(systemName: "plus")
                                    }
                                }
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EditButton()
                                }
                            }
                            .sheet(isPresented: $showingAddDebt) {
                                AddDebtView()
                            }
                        }
                    }

                    private func calculate() {
                        let extra = Double(extraPayment) ?? 0
                        result = strategy == .avalanche
                            ? calculator.calculateAvalanche(debts: debts, extraPayment: extra)
                            : calculator.calculateSnowball(debts: debts, extraPayment: extra)
                    }

                    private func deleteDebts(offsets: IndexSet) {
                        for index in offsets {
                            modelContext.delete(debts[index])
                        }
                    }
                }

                #Preview {
                    DebtCalculatorView()
                        .modelContainer(for: Debt.self, inMemory: true)
                }
