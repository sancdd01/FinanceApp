//
//  Bill.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/19/26.
//

import Foundation
import SwiftData

enum BillStatus: String, Codable { case upcoming, dueToday, overdue, paid }

@Model
final class Bill {
    var id: UUID
    var name: String
    var amount: Double
    var dayOfMonth: Int // 1-31
    var status: BillStatus
    var category: String?
    var isAutopay: Bool
    var notes: String?
    
    init(name: String, amount: Double, dayOfMonth: Int, status: BillStatus = .upcoming, category: String? = nil, isAutopay: Bool = false, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.dayOfMonth = dayOfMonth
        self.status = status
        self.category = category
        self.isAutopay = isAutopay
        self.notes = notes
    }
}
