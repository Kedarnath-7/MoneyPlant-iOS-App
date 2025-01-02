//
//  CoreDataHelper.swift
//  SavingTransactions
//
//  Created by admin86 on 23/12/24.
//

import UIKit
import CoreData

extension PersistenceController{
    
    // MARK: - Preloading Data
    func preloadAccount() {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let account = Account(context: context)
                account.id = UUID()
                account.name = "Default Account"
                account.type = "Savings" // Adjust as needed
                account.initialBalance = 0.0
                account.balance = 0.0 // Set initial balance
                
                saveContext()
                print("Preloaded default account with balance 0.0.")
            } else {
                print("Account already exists.")
            }
        } catch {
            print("Error preloading account: \(error)")
        }
    }
    
    func preloadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let defaultCategories = [
                    (name: "Food", type: "Expense", icon: UIImage(systemName: "fork.knife")),
                    (name: "Rent", type: "Expense", icon: UIImage(systemName: "house")),
                    (name: "Medical", type: "Expense", icon: UIImage(systemName: "cross.case.fill")!),
                    (name: "Party", type: "Expense", icon: UIImage(systemName: "party.popper.fill")!), (name: "Add New", type: "Expense", icon: UIImage(systemName: "plus")!),
                    
                    (name: "Salary", type: "Income", icon: UIImage(systemName: "dollarsign.circle")),
                    (name: "Freelance", type: "Income", icon: UIImage(systemName: "briefcase")), (name: "Add New",  type: "Income", icon: UIImage(systemName: "plus")!)
                ]
                
                for categoryData in defaultCategories {
                    let category = Category(context: context)
                    category.id = UUID()
                    category.name = categoryData.name
                    category.type = categoryData.type
                    
                    if let icon = categoryData.icon,
                       let imageData = icon.pngData() { // Convert UIImage to Data
                        category.icon = imageData
                    }
                }
                
                try context.save()
                print("Preloaded default categories with icons as binary data.")
            } else {
                print("Default categories already exist.")
            }
        } catch {
            print("Error preloading data: \(error)")
        }
    }
    
    func preloadData() {
        preloadAccount()
        preloadCategories()
    }
    
    func fetchAccount() -> Account? {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        do {
            // Assuming there's only one account; fetch the first one
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching account: \(error)")
            return nil
        }
    }
    
    // MARK: - CRUD Operations
    func addTransaction(_ transaction: Transaction) {
        saveContext()
    }
    
    func addCategory(id: UUID,name: String, type: String, icon: UIImage, description: String?) {
        let category = Category(context: context)
        category.id = id
        category.name = name
        category.type = type
        let categoryIcon = icon
        let imageData = icon.pngData() 
        category.icon = imageData!
        
        category.descriptionOfCategory = description
        
        saveContext()
    }
    
    // MARK: - Fetch Operations
    func fetchTransactions() -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }
    
    func fetchCategories(for type: String) -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        PersistenceController.shared.context.delete(transaction)
        do {
            try PersistenceController.shared.context.save()
        } catch {
            print("Error deleting transaction: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Budget Operations
    func createBudget(monthYear: String, income: Double, budgetAmount: Double) {
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.monthYear = monthYear
        budget.income = income
        budget.budgetAmount = budgetAmount
        budget.totalExpenses = 0.0
        
        saveContext()
        print("Budget created for \(monthYear).")
    }
    
    func fetchBudget(for monthYear: String) -> Budget? {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "monthYear == %@", monthYear)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching budget: \(error)")
            return nil
        }
    }
    
    func deleteBudget(_ budget: Budget) {
        context.delete(budget)
        saveContext()
        print("Budget deleted for \(budget.monthYear).")
    }
    
    func generateDailyTargets(for budget: Budget) {
        let monthYear = budget.monthYear
        guard let daysInMonth = getDaysInMonth(from: monthYear) else { return }
        
        for day in 1...daysInMonth {
            let dailyTarget = DailyTarget(context: context)
            dailyTarget.id = UUID()
            dailyTarget.date = createDate(from: day, monthYear: monthYear)!
            dailyTarget.targetExpense = budget.budgetAmount / Double(daysInMonth)
            dailyTarget.actualExpense = 0.0
            dailyTarget.savingsAchieved = dailyTarget.targetExpense
            dailyTarget.budget = budget
            
            budget.addToDailyTargets(dailyTarget)
        }
        
        saveContext()
        print("Daily targets generated for \(monthYear).")
    }
    
    func updateDailyTargets(for budget: Budget, transactions: [Transaction]) {
        for transaction in transactions {
            if let dailyTarget = fetchDailyTarget(for: transaction.date, budget: budget) {
                dailyTarget.actualExpense += transaction.amount
                dailyTarget.savingsAchieved = max(0, dailyTarget.targetExpense - dailyTarget.actualExpense)
            }
        }
        
        saveContext()
        print("Daily targets updated for \(budget.monthYear).")
    }

    func fetchDailyTarget(for date: Date, budget: Budget) -> DailyTarget? {
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND budget == %@", date as NSDate, budget)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching daily target: \(error)")
            return nil
        }
    }

    func getDaysInMonth(from monthYear: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        guard let date = formatter.date(from: monthYear) else { return nil }
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }

    func createDate(from day: Int, monthYear: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        guard let baseDate = formatter.date(from: monthYear) else { return nil }
        
        var components = Calendar.current.dateComponents([.year, .month], from: baseDate)
        components.day = day
        
        return Calendar.current.date(from: components)
    }

}
