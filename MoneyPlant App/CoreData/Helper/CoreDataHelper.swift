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
    
    func updateTransaction(transaction: Transaction, paidTo: String?, amount: Double?, date: Date?, note: String?) {
        if let paidTo = paidTo {
            transaction.paidTo = paidTo
            print("Updated paidTo for \(transaction): \(paidTo)")
        }
        if let amount = amount {
            transaction.amount = amount
            print("Updated amount for \(transaction): \(amount)")
        }
        if let date = date {
            transaction.date = date
            print("Updated date for \(transaction): \(date)")
        }
        if let note = note {
            transaction.note = note
            print("Updated date for \(transaction): \(note)")
        }
        saveContext()
    }
    
    func addCategory(id: UUID,name: String, type: String, icon: UIImage, description: String?) {
        let category = Category(context: context)
        category.id = id
        category.name = name
        category.type = type
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

    func addBudget(income: Double, budgetAmount: Double, monthYear: String) -> Budget? {
        if let existingBudget = fetchBudget(for: monthYear) {
            print("Budget for \(monthYear) already exists: \(existingBudget)")
            return existingBudget
        }
        
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.totalIncome = income
        budget.budgetedAmount = budgetAmount
        budget.monthYear = monthYear
        budget.totalExpenses = 0.0
        saveContext()
        print("Budget created for \(monthYear).")
        return budget
    }


    func fetchBudget(for monthYear: String) -> Budget? {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "monthYear == %@", monthYear)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching budget for \(monthYear): \(error.localizedDescription)")
            return nil
        }
    }

    func fetchBudgets() -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching budgets: \(error.localizedDescription)")
            return []
        }
    }

    func updateBudget(budget: Budget, income: Double?, budgetAmount: Double?, totalExpenses: Double?) {
        if let income = income {
            budget.totalIncome = income
            print("Updated income for \(budget.monthYear): \(income)")
        }
        if let budgetAmount = budgetAmount {
            budget.budgetedAmount = budgetAmount
            print("Updated budget amount for \(budget.monthYear): \(budgetAmount)")
        }
        if let totalExpenses = totalExpenses {
            budget.totalExpenses = totalExpenses
            print("Updated total expenses for \(budget.monthYear): \(totalExpenses)")
        }
        saveContext()
    }

    func deleteBudget(budget: Budget) {
        context.delete(budget)
        saveContext()
    }

    func addCategoryBudget(for budget: Budget, category: Category, budgetedAmount: Double) -> CategoryBudget? {
        // Check if a category budget already exists for this category in the given budget
        let existingBudgets = fetchCategoryBudgets(for: budget).filter { $0.category == category }
        if let existingBudget = existingBudgets.first {
            print("Category budget for \(category.name) already exists in \(budget.monthYear).")
            return existingBudget
        }
        
        let categoryBudget = CategoryBudget(context: context)
        categoryBudget.id = UUID()
        categoryBudget.spentAmount = 0.0
        categoryBudget.budgetedAmount = budgetedAmount
        categoryBudget.budget = budget
        categoryBudget.category = category
        saveContext()
        print("Category budget added for \(category.name) in \(budget.monthYear).")
        return categoryBudget
    }


    func fetchCategoryBudgets(for budget: Budget?) -> [CategoryBudget] {
        guard let budget = budget else {
            print("No budget provided to fetch category budgets.")
            return []
        }
        
        let fetchRequest: NSFetchRequest<CategoryBudget> = CategoryBudget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "budget == %@", budget)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching category budgets for \(budget.monthYear): \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchCategoryBudget(for category: Category, monthYear: String) -> CategoryBudget? {
        let fetchRequest: NSFetchRequest<CategoryBudget> = CategoryBudget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@ AND monthYear == %@", category, monthYear)
        do {
            return try context.fetch(fetchRequest).first
        }catch {
            print("Error fetching category budget for \(category.name) \(monthYear): \(error.localizedDescription)")
            return nil
        }
    }

    func updateCategoryBudget(categoryBudget: CategoryBudget, spentAmount: Double?, budgetedAmount: Double?) {
        if let spentAmount = spentAmount {
            categoryBudget.spentAmount = spentAmount
        }
        if let budgetedAmount = budgetedAmount {
            categoryBudget.budgetedAmount = budgetedAmount
        }
        saveContext()
    }

    func deleteCategoryBudget(categoryBudget: CategoryBudget) {
        context.delete(categoryBudget)
        saveContext()
    }

    func validateCategoryBudgets(for budget: Budget) -> Bool {
        let categoryBudgets = fetchCategoryBudgets(for: budget)
        let totalCategoryBudget = categoryBudgets.reduce(0) { $0 + $1.budgetedAmount }
        
        if totalCategoryBudget > budget.budgetedAmount {
            print("Total category budgets (\(totalCategoryBudget)) exceed the total budget (\(budget.budgetedAmount)).")
            return false
        }
        print("Category budgets are valid.")
        return true
    }

    
    func addDailyTarget(budget: Budget, date: Date, targetExpense: Double) {
        let dailyTarget = DailyTarget(context: context)
        dailyTarget.id = UUID()
        dailyTarget.date = date
        dailyTarget.actualExpense = 0.0
        dailyTarget.isCompleted = false
        dailyTarget.savingsAchieved = 0.0
        dailyTarget.targetExpense = targetExpense
        //dailyTarget.budget = budget
        saveContext()
    }
        
    func fetchDailyTargets(for budget: Budget) -> [DailyTarget] {
        let fetchRequest: NSFetchRequest<DailyTarget> = DailyTarget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "budget == %@", budget)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching daily targets: \(error)")
            return []
        }
    }
    
    func generateDailyTargets(for budget: Budget) {
        let monthYear = budget.monthYear
        guard let daysInMonth = getDaysInMonth(from: monthYear) else { return }
        
        for day in 1...daysInMonth {
            let dailyTarget = DailyTarget(context: context)
            dailyTarget.id = UUID()
            dailyTarget.date = createDate(from: day, monthYear: monthYear)!
            dailyTarget.targetExpense = budget.budgetedAmount / Double(daysInMonth)
            dailyTarget.actualExpense = 0.0
            dailyTarget.savingsAchieved = dailyTarget.targetExpense
           // dailyTarget.budget = budget
            
        //budget.addToDailyTargets(dailyTarget)
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
    
    func daysLeftInMonth(from monthYear: String) -> Int? {
        guard let totalDays = getDaysInMonth(from: monthYear) else { return nil }
        let today = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
        return totalDays - today
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
