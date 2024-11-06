//
//  Categories.swift
//  MoneyPlant App
//
//  Created by admin86 on 06/11/24.
//

import UIKit

struct Categories {
    var name: String
    var symbol: UIImage
    var type : String
}

var categories: [Categories] = [
    Categories(name: "Food", symbol: UIImage(systemName: "fork.knife.circle.fill")!, type: "Expense"),
    Categories(name: "Fuel", symbol: UIImage(systemName: "fuelpump.circle.fill")!, type: "Expense"),
    Categories(name: "Shopping ", symbol: UIImage(systemName: "cart.circle.fill")!, type: "Expense"),
    Categories(name: "Medical", symbol: UIImage(systemName: "cross.case.circle.fill")!, type: "Expense"),
    Categories(name: "Party", symbol: UIImage(systemName: "party.popper.circle.fill")!, type: "Expense"),
    Categories(name: "Service", symbol: UIImage(systemName: "car.side.front.open.circle.fill")!, type: "Expense"),
    Categories(name: "Movie", symbol: UIImage(systemName: "movieclapper.circle.fill")!, type: "Expense"),
    Categories(name: "Tea", symbol: UIImage(systemName: "cup.and.saucer.circle.fill")!, type: "Expense"),
]
