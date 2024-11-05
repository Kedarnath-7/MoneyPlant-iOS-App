//
//  Transactions.swift
//  MoneyPlant App
//
//  Created by admin86 on 05/11/24.
//

import UIKit

struct Transactions{
    var symbol: UIImage
    var name: String
    var amount: Double
    var category: String
}

var transactions: [Transactions] = [
    Transactions(symbol: UIImage(systemName: "fork.knife.circle.fill")!, name: "Dinner",
                 amount: 500.00, category: "Food"),
    Transactions(symbol: UIImage(systemName: "bag.circle.fill")!, name: "Dress",
                 amount: 1000.00, category: "Shopping"),
    Transactions(symbol: UIImage(systemName: "fuelpump.circle.fill")!, name: "Car Petrol",
                 amount: 2500.00, category: "Fuel"),
    Transactions(symbol: UIImage(systemName: "car.circle.fill")!, name: "Car",
                 amount: 6000.00, category: "Service")
]
