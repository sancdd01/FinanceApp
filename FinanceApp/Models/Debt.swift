//
//  Debt.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/19/26.
//


import Foundation
import SwiftData

@Model
final class Debt {
    var id: UUID
    var creditorName: String
    var balance: Double
    var interestRate: Double // annual %
    var minimumPayment: Double
    
    init(creditorName: String, balance: Double, interestRate: Double, minimumPayment: Double) {
        self.id = UUID()
        self.creditorName = creditorName
        self.balance = balance
        self.interestRate = interestRate
        self.minimumPayment = minimumPayment
    }
}
