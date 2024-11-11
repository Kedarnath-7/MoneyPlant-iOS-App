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

var expenseCategories: [Categories] = [
    Categories(name: "Food", symbol: UIImage(systemName: "fork.knife")!, type: "Expense"),
    Categories(name: "Fuel", symbol: UIImage(systemName: "fuelpump.fill")!, type: "Expense"),
    Categories(name: "Medical", symbol: UIImage(systemName: "cross.case.fill")!, type: "Expense"),
    Categories(name: "Party", symbol: UIImage(systemName: "party.popper.fill")!, type: "Expense"),
    Categories(name: "Service", symbol: UIImage(systemName: "car.fill")!, type: "Expense"),
    Categories(name: "Shopping ", symbol: UIImage(systemName: "cart.fill")!, type: "Expense"),
    Categories(name: "Movie", symbol: UIImage(systemName: "movieclapper.fill")!, type: "Expense"),
    Categories(name: "Tea", symbol: UIImage(systemName: "cup.and.saucer.fill")!, type: "Expense"),
    Categories(name: "Add New", symbol: UIImage(systemName: "plus")!, type: "Expense"),

]

var incomeCategories: [Categories] = [
    Categories(name: "Salary", symbol: UIImage(systemName: "indianrupeesign")!, type: "Income"),
    Categories(name: "Tutoring", symbol: UIImage(systemName: "book.fill")!, type: "Income"),
    Categories(name: "Rent", symbol: UIImage(systemName: "house.lodge.fill")!, type: "Income"),
    Categories(name: "Investment", symbol: UIImage(systemName: "indianrupeesign.gauge.chart.leftthird.topthird.rightthird")!, type: "Income"),
    Categories(name: "Part Time", symbol: UIImage(systemName: "person.crop.circle.badge.clock.fill")!, type: "Income"),
    Categories(name: "Add New", symbol: UIImage(systemName: "plus")!, type: "Income"),
]
