//
//  DebtCollector.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/19/26.
//

import Foundation

struct PaymentEntry {
    let debtId: UUID
    let amount: Double
    let remainingBalance: Double
}

struct MonthlySchedule {
    let month: String
    let payments: [PaymentEntry]
}

struct PaymentScheduleResult {
    let schedule: [MonthlySchedule]
    let totalInterestPaid: Double
    let payoffTimeMonths: Int
    let totalAmountPaid: Double
}

struct DebtCalculator {
    func calculatorAvalanche(debts: [Debt], extraPayment: Double) -> PaymentScheduleResult {
        let sorted = debts.sorted { $0.interestRate > $1.interestRate }
        return simulatePayments(debts: sorted, extraPayment: extraPayment)
    }
    
    func calculateSnowball(debts: [Debt], extraPayment: Double) -> PaymentScheduleResult {
        let sorted = debts.sorted { $0.balance < $1.balance }
        return simulatePayments(debts: sorted, extraPayment: extraPayment)
    }
    
    private func simulatePayments(debts: [Debt], extraPayment: Double) -> PaymentScheduleResult {
        var schedule: [MonthlySchedule] = []
        var working = debts.map { DebtSnapshot(id: $0.id, balance: $0.balance, interestRate: $0.interestRate, minimumPayment: $0.minimumPayment) }
        var totalInterest = 0.0
        var totalPaid = 0.0
        var month = 0
        
        while working.contains(where: { $0.balance > 0}) {
            month += 1
            if month > 600 {break}
            
            // Apply monthly interest
            for i in working.indices where working[i].balance > 0 {
                let interest = working[i].balance * (working[i].interestRate / 12 / 100)
                working[i].balance += interest
                totalInterest += interest
            }
            
            // Process payments
            var remainingExtra = extraPayment
            var payments: [PaymentEntry] = []
            
            for i in working.indices {
                guard working[i].balance > 0 else {
                    payments.append(PaymentEntry(debtId: working[i].id, amount: 0, remainingBalance: 0))
                    continue
                }
                var payment = working[i].minimumPayment + remainingExtra
                remainingExtra = 0
                let actual = min(payment, working[i].balance)
                if payment > actual { remainingExtra += payment - actual }
                working[i].balance -= actual
                totalPaid += actual
                payments.append(PaymentEntry(debtId: working[i].id, amount: actual, remainingBalance: max(0, working[i].balance)))
            }
            
            schedule.append(MonthlySchedule(month: monthLabel(for: month), payments: payments))
        }
        
        return PaymentScheduleResult(schedule: schedule, totalInterestPaid: totalInterest, payoffTimeMonths: month, totalAmountPaid: totalPaid)
    }
    
    private func monthLabel(for offset: Int) -> String {
        let date = Calendar.current.date(byAdding: .month, value: offset - 1, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM yyyy"
        return formatter.string(from: date)
    }
}

// Internal working copy - avoids mutating SwiftData models during simulation
private struct DebtSnapshot {
    let id: UUID
    var balance: Double
    let interestRate: Double
    let minimumPayment: Double
}
