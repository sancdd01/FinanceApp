//
//  FinanceAppTests.swift
//  FinanceAppTests
//
//  Created by Derrick Sanchez on 4/28/26.
//

import Testing
@testable import FinanceApp

// MARK: - Helpers

private func debt(_ creditor: String, balance: Double, rate: Double, min: Double) -> Debt {
    Debt(creditorName: creditor, balance: balance, interestRate: rate, minimumPayment: min)
}

// MARK: - Tests

struct DebtCalculatorTests {
    let calc = DebtCalculator()

    @Test func avalancheSortsByHighestRate() {
        // With extra payment, avalanche targets the high-rate debt first,
        // so it clears sooner and produces less total interest than snowball order.
        let low  = debt("Low",  balance: 1000, rate: 5,  min: 50)
        let high = debt("High", balance: 1000, rate: 20, min: 50)

        let avalanche = calc.calculateAvalanche(debts: [low, high], extraPayment: 100)
        let snowball  = calc.calculateSnowball(debts: [low, high],  extraPayment: 100)

        // Avalanche (highest rate first) should pay less total interest
        #expect(avalanche.totalInterestPaid < snowball.totalInterestPaid)
    }

    @Test func snowballSortsByLowestBalance() {
        let small = debt("Small", balance: 200,  rate: 10, min: 30)
        let large = debt("Large", balance: 2000, rate: 10, min: 30)

        let result = calc.calculateSnowball(debts: [large, small], extraPayment: 0)

        let smallClears = result.schedule.firstIndex { $0.payments.contains { $0.debtId == small.id && $0.remainingBalance == 0 } }
        let largeClears = result.schedule.firstIndex { $0.payments.contains { $0.debtId == large.id && $0.remainingBalance == 0 } }

        #expect(smallClears != nil && largeClears != nil)
        #expect(smallClears! <= largeClears!)
    }

    @Test func extraPaymentRollsOver() {
        // Debt A pays off fast; surplus should accelerate Debt B
        let a = debt("A", balance: 100,  rate: 0, min: 50)
        let b = debt("B", balance: 1000, rate: 0, min: 50)

        let withExtra    = calc.calculateAvalanche(debts: [a, b], extraPayment: 50)
        let withoutExtra = calc.calculateAvalanche(debts: [a, b], extraPayment: 0)

        #expect(withExtra.payoffTimeMonths < withoutExtra.payoffTimeMonths)
    }

    @Test func payoffTerminatesWithinCap() {
        let d = debt("X", balance: 5000, rate: 18, min: 100)
        let result = calc.calculateAvalanche(debts: [d], extraPayment: 0)

        #expect(result.payoffTimeMonths > 0)
        #expect(result.payoffTimeMonths <= 600)
        #expect(result.schedule.last?.payments.allSatisfy { $0.remainingBalance == 0 } == true)
    }

    @Test func totalPaidEqualsBalancePlusInterest() {
        let d = debt("X", balance: 1000, rate: 12, min: 100)
        let result = calc.calculateAvalanche(debts: [d], extraPayment: 0)

        #expect(abs(result.totalAmountPaid - (1000 + result.totalInterestPaid)) < 0.01)
    }
}
