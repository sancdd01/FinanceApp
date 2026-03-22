//
//  ContentView.swift
//  FinanceApp
//
//  Created by Derrick Sanchez on 3/18/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            DebtCalculatorView()
                .tabItem {
                    Label("Debts", systemImage: "creditcard")
                }
            BillOrganizerView()
                .tabItem {
                    Label("Bills", systemImage: "list.bullet.rectangle")
                }
        }
    }
}

#Preview {
    ContentView()
}
