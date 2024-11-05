//
//  Transactions.swift
//  MoneyPlant App
//
//  Created by admin86 on 05/11/24.
//

struct Transactions{
    var symbol: String
    var name: String
    var amount: Double
    var category: String
}

var transactions: [Transactions] = [
    Transactions(symbol: "􀸹", name: "Dinner",
                 amount: 500.00, category: "Food"),
    Transactions(symbol: "􀒭", name: "Dress",
                 amount: 1000.00, category: "Shopping"),
    Transactions(symbol: "􀵠", name: "Car Petrol",
                 amount: 2500.00, category: "Fuel"),
    Transactions(symbol: "􀭯", name: "Car",
                 amount: 6000.00, category: "Service")
]
