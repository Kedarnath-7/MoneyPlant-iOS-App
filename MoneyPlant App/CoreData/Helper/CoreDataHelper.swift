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
        let fetchRequest: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let user = UserAccount(context: context)
                user.firstName = ""
                user.lastName = ""
                user.email = ""
                user.plantCoins = 10000
                user.onBoardingRequired = true
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
                    (name: "Food", type: "Expense", icon: "🍽️"),
                    (name: "Groceries", type: "Expense", icon: "🛒"),
                    (name: "Coffee/Tea", type: "Expense", icon: "☕️"),
                    (name: "Snacks", type: "Expense", icon: "🍿"),
                    (name: "Clothing", type: "Expense", icon: "👔"),
                    (name: "Accessories", type: "Expense", icon: "👟"),
                    (name: "Electronics", type: "Expense", icon: "🎧"),
                    (name: "Movie", type: "Expense", icon: "🎥"),
                    (name: "Subscriptions", type: "Expense", icon: "📅"),
                    (name: "Books", type: "Expense", icon: "📚"),
                    (name: "Gas/Fuel", type: "Expense", icon: "⛽️"),
                    (name: "Haircut", type: "Expense", icon: "💇"),
                    (name: "Phone", type: "Expense", icon: "📱"),
                    (name: "Transportation", type: "Expense", icon: "🚆"),
                    (name: "Travel", type: "Expense", icon: "🛫"),
                    (name: "Health", type: "Expense", icon: "🏥"),
                    (name: "Rent", type: "Expense", icon: "🏠"),
                    (name: "Vegetables", type: "Expense", icon: "🥕"),
                    (name: "Fruits", type: "Expense", icon: "🍎"),
                    (name: "Add New",  type: "Expense", icon: "➕"),

                    (name: "Pay Check", type: "Income", icon: "💰"),
                    (name: "Investments", type: "Income", icon: "📈"),
                    (name: "Bonus", type: "Income", icon: "🎉"),
                    (name: "Freelance", type: "Income", icon: "🧑‍💻"),
                    (name: "Others", type: "Income", icon: "💡"),
                    (name: "Add New",  type: "Income", icon: "➕")
                ]
                
                for categoryData in defaultCategories {
                    let category = Category(context: context)
                    category.id = UUID()
                    category.name = categoryData.name
                    category.type = categoryData.type
                    category.icon = categoryData.icon
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
    
    func preloadStoreData() {
        let specieFetch: NSFetchRequest<PlantSpecie> = PlantSpecie.fetchRequest()
        let environmentFetch: NSFetchRequest<Environment> = Environment.fetchRequest()
        
        do {
            let specieCount = try context.count(for: specieFetch)
            let environmentCount = try context.count(for: environmentFetch)

            if specieCount == 0 && environmentCount == 0 {
                print("Preloading default Plant Species and Environments...")

                let defaultSpecieName = "Flower"
                let defaultEnvironmentName = "Cliff_House"

                let plantSpecies = [
                    ("Tuple", "Tuple.png", 100),
                    ("Palm", "Palm.png", 150),
                    ("Flower", "Flower.png", 200),
                    ("Banana", "Banana.png", 250),
                    ("Mushroom", "Mushroom.png", 300)
                ]

                let environments = [
                    ("Cliff_House", "Cliff_House.png", 100),
                    ("Forest_House", "Forest_House.png", 150),
                    ("Mountain_House", "Mountain_House.png", 200),
                    ("Low_Poly_Mill", "Low_Poly_Mill.png", 250),
                    ("Low_Poly_House", "Low_Poly_House.png", 300)
                ]

                for (name, image, requiredCoins) in plantSpecies {
                    let specie = PlantSpecie(context: context)
                    specie.name = name
                    specie.image = image
                    specie.requiredCoins = Int64(requiredCoins)
                    specie.isUnlocked = (name == defaultSpecieName)
                }

                for (name, image, requiredCoins) in environments {
                    let environment = Environment(context: context)
                    environment.name = name
                    environment.image = image
                    environment.requiredCoins = Int64(requiredCoins)
                    environment.isUnlocked = (name == defaultEnvironmentName)
                }

                try context.save()
                print("Default Plant Species and Environments preloaded successfully.")
            } else {
                print("Default Plant Species and Environments already exist.")
            }
        } catch {
            print("Error preloading store data: \(error)")
        }
    }

    
    func preloadData() {
        preloadAccount()
        preloadCategories()
        preloadStoreData()
    }
    
    func fetchUser() -> UserAccount? {
        let fetchRequest: NSFetchRequest<UserAccount> = UserAccount.fetchRequest()
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching account: \(error)")
            return nil
        }
    }
    
    // MARK: - CRUD Operations
    func addTransaction(paidTo: String, amount: Double, date: Date, note: String?, categoryID: NSManagedObjectID) -> Transaction? {
        let context = PersistenceController.shared.context
            
        guard let categoryInContext = context.object(with: categoryID) as? Category else {
            print("❌ Failed to retrieve category in current context!")
            return nil
        }
        
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.paidTo = paidTo
        transaction.amount = amount
        transaction.date = date
        transaction.note = note
        transaction.category = categoryInContext
        transaction.type = categoryInContext.type

        saveContext()

        print("✅ Added Transaction: \(formatToLocalDate(date)), Amount: \(amount)")

        if transaction.type == "Expense" {
            updateRelatedBudgetData(for: transaction)
        }

        return transaction
    }
    
    func updateTransaction(transaction: Transaction, paidTo: String?, amount: Double?, date: Date?, note: String?) {
        let previousDate = transaction.date
        let previousAmount = transaction.amount

        if let paidTo = paidTo {
            transaction.paidTo = paidTo
        }
        if let amount = amount {
            transaction.amount = amount
        }
        if let date = date {
            transaction.date = date
        }
        if let note = note {
            transaction.note = note
        }

        saveContext()

        print("🔄 Updated Transaction: \(formatToLocalDate(transaction.date)), Amount: \(transaction.amount)")

        if transaction.type == "Expense" && (transaction.date != previousDate || transaction.amount != previousAmount) {
            print("🔄 Recalculating budgets due to transaction update")

            if let oldDailyAllocation = fetchDailyAllocation(for: transaction, on: previousDate) {
                print("🔄 Adjusting old DailyAllocation spent for: \(formatToLocalDate(previousDate))")
                oldDailyAllocation.spentAmount -= previousAmount
            }

            updateRelatedBudgetData(for: transaction)
        }
    }

    func updateRelatedBudgetData(for transaction: Transaction) {
        let calendar = Calendar.current
        let transactionDate = calendar.startOfDay(for: transaction.date)

        print("🔄 Updating budget data for transaction on \(formatToLocalDate(transactionDate))")

        guard let dailyAllocation = fetchDailyAllocation(for: transaction) else {
            print("❌ No matching DailyAllocation found for transaction on \(formatToLocalDate(transactionDate))")
            return
        }

        print("✅ Found DailyAllocation for date: \(formatToLocalDate(dailyAllocation.date))")
        updateDailyAllocationSpent(for: dailyAllocation)
    }

    func addCategory(id: UUID,name: String, type: String, icon: String, description: String?) -> Category {
        let category = Category(context: context)
        category.id = id
        category.name = name
        category.type = type
        category.icon = icon
        category.descriptionOfCategory = description
        
        saveContext()
        return category
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
    
    func fetchTransactions(date: Date? = nil, weekStartDate: Date? = nil, weekEndDate: Date? = nil) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        var predicates: [NSPredicate] = []
        let calendar = Calendar.current

        if let date = date {
            let startOfDay = calendar.startOfDay(for: date)
            print("Start of Day: \(formatToLocalDate(startOfDay))")
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            print("End of Day: \(formatToLocalDate(endOfDay))")
            
            predicates.append(NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg))
        }
        
        if let weekStartDate = weekStartDate, let weekEndDate = weekEndDate {
            predicates.append(NSPredicate(format: "date >= %@ AND date <= %@", weekStartDate as CVarArg, weekEndDate as CVarArg))
        }
        predicates.append(NSPredicate(format: "type == %@", "Expense"))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        do {
            let transactions = try context.fetch(fetchRequest)
            print("✅ Found \(transactions.count) transactions for date: \(formatToLocalDate(((date) ?? (weekStartDate))!))")
            return transactions
        } catch {
            print("❌ Error fetching transactions: \(error)")
            return []
        }
    }
    
    func fetchTransactions(for timeFilter: String, selectedDate: Date) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let calendar = Calendar.current
        var startDate: Date
        var endDate: Date

        switch timeFilter {
        case "Weekly":
            startDate = calendar.dateInterval(of: .weekOfMonth, for: selectedDate)!.start
            endDate = calendar.dateInterval(of: .weekOfMonth, for: selectedDate)!.end
        case "Monthly":
            startDate = calendar.dateInterval(of: .month, for: selectedDate)!.start
            endDate = calendar.dateInterval(of: .month, for: selectedDate)!.end
        case "Yearly":
            startDate = calendar.dateInterval(of: .year, for: selectedDate)!.start
            endDate = calendar.dateInterval(of: .year, for: selectedDate)!.end
        default:
            return []
        }

        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate)
        fetchRequest.predicate = datePredicate

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch transactions: \(error)")
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
    
    func fetchOrCreateCategory(name: String, type: String) -> Category {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if let existingCategory = try context.fetch(fetchRequest).first {
                return existingCategory  // ✅ Return existing category if found
            }
        } catch {
            print("Error fetching category: \(error)")
        }
        
        // ✅ If not found, create a new category
        let newCategory = Category(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.type = type
        return newCategory
    }
    
    func deleteTransaction(transaction: Transaction) {
        guard let context = transaction.managedObjectContext else {
            print("⚠️ Skipping deletion: Transaction not in Core Data")
            return
        }
        
        let transactionDate = transaction.date // Save date before deletion
        let transactionAmount = transaction.amount

        // Update DailyAllocation before deleting
        if let dailyAllocation = fetchDailyAllocation(for: transaction) {
            print("🗑 Adjusting spentAmount before deleting transaction on \(formatToLocalDate(transactionDate))")
            dailyAllocation.spentAmount -= transactionAmount

            // Update WeeklyBudget spent amount
            updateWeeklyBudgetSpent(for: dailyAllocation.weeklyBudget)
        } else {
            print("⚠️ No DailyAllocation found for transaction before deletion!")
        }

        context.delete(transaction)
        saveContext()
        print("🗑 Deleted Transaction: \(formatToLocalDate(transactionDate))")
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
        budget.monthEndDate = monthEndDate(from: monthYear)!
        budget.isMonthFinalized = false
        saveContext()
        
        print("Budget created for \(monthYear).")
        
        let plant = fetchOrCreatePlant(for: budget)
        print("Plant \(plant.plantSpecie.name) created for budget \(budget.monthYear).")
        
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
    
    func fetchAllNotFinalizedMonthlyBudgets(date: Date) -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(isMonthFinalized == %@) AND (monthEndDate < %@)", false, date as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "monthEndDate", ascending: false)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching all month budgets: \(error.localizedDescription)")
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
    
    func updateMonthlyBudgetSpent(for monthlyBudget: Budget) {
        let weeklyBudgets = fetchWeeklyBudgets(for: monthlyBudget)
        let totalExpenses = weeklyBudgets.reduce(0.0) { $0 + $1.spentAmount }
        
        print("📊 Updating MonthlyBudget spent for: \(monthlyBudget.monthYear) - \(formatToLocalDate(monthlyBudget.monthEndDate))")
        
        monthlyBudget.totalExpenses = totalExpenses
        monthlyBudget.isMonthFinalized = false
        
        saveContext()
    }

    
    // MARK: - Weekly Budget Operations

    func addWeeklyBudget(for budget: Budget, weekStartDate: Date, weekEndDate: Date, allocatedAmount: Double) -> WeeklyBudget? {
        let calendar = Calendar(identifier: .gregorian)
        let normalizedStartDate = calendar.startOfDay(for: weekStartDate) // 00:00:00
        let normalizedEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: weekEndDate)! // 23:59:59

        print("addWeeklyBudget method - weekStart date: \(formatToLocalDate(normalizedStartDate)), weekEnd date: \(formatToLocalDate(normalizedEndDate)), allocated amount: \(allocatedAmount)")

        let existingBudgets = fetchWeeklyBudgets(for: budget).filter {
            calendar.isDate($0.weekStartDate, inSameDayAs: normalizedStartDate) && calendar.isDate($0.weekEndDate, inSameDayAs: normalizedEndDate)
        }

        if let existingBudget = existingBudgets.first {
            print("✅ Weekly budget already exists for \(formatToLocalDate(normalizedStartDate)) - \(formatToLocalDate(normalizedEndDate))")
            existingBudget.allocatedAmount = allocatedAmount
            return existingBudget
        }

        let weeklyBudget = WeeklyBudget(context: context)
        weeklyBudget.id = UUID()
        weeklyBudget.weekStartDate = normalizedStartDate
        weeklyBudget.weekEndDate = normalizedEndDate
        weeklyBudget.allocatedAmount = allocatedAmount
        weeklyBudget.spentAmount = 0.0
        weeklyBudget.budget = budget

        saveContext()
        print("✅ Weekly budget added for \(formatToLocalDate(normalizedStartDate)) - \(formatToLocalDate(normalizedEndDate))")
        return weeklyBudget
    }

    func fetchWeeklyBudgets(for budget: Budget) -> [WeeklyBudget] {
        let fetchRequest: NSFetchRequest<WeeklyBudget> = WeeklyBudget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "budget == %@", budget)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching weekly budgets for \(budget.monthYear): \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchWeeklyBudgetForDate(_ date: Date) -> WeeklyBudget? {
        let fetchRequest: NSFetchRequest<WeeklyBudget> = WeeklyBudget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(weekStartDate <= %@) AND (weekEndDate >= %@)", date as NSDate, date as NSDate)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching weekly budget for date \(date): \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllNotFinalizedWeeklyBudgets(date: Date) -> [WeeklyBudget] {
        let fetchRequest: NSFetchRequest<WeeklyBudget> = WeeklyBudget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(isWeekFinalized == 0) AND (weekEndDate < %@)", date as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "weekEndDate", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching all weekly budgets: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateWeeklyBudget(weeklyBudget: WeeklyBudget, spentAmount: Double?, allocatedAmount: Double?) {
        if let spentAmount = spentAmount {
            weeklyBudget.spentAmount = spentAmount
        }
        if let allocatedAmount = allocatedAmount {
            weeklyBudget.allocatedAmount = allocatedAmount
        }
        saveContext()
    }
    
    func updateWeeklyBudgetSpent(for weeklyBudget: WeeklyBudget) {
        let dailyAllocations = fetchDailyAllocations(for: weeklyBudget)
        let totalSpent = dailyAllocations.reduce(0.0) { $0 + $1.spentAmount }

        print("📊 Updating WeeklyBudget spent for: \(formatToLocalDate(weeklyBudget.weekStartDate)) - \(formatToLocalDate(weeklyBudget.weekEndDate))")
        print("📝 Found \(dailyAllocations.count) daily allocations. Total spent: \(totalSpent)")

        weeklyBudget.spentAmount = totalSpent
        weeklyBudget.isWeekFinalized = false
        saveContext()
    }
    
    
    
    // MARK: - Daily Allocation Operations

    func addDailyAllocation(for weeklyBudget: WeeklyBudget, date: Date, allocatedAmount: Double) -> DailyAllocation? {
        let calendar = Calendar.current

        let existingAllocations = fetchDailyAllocations(for: weeklyBudget).filter {
            calendar.isDate($0.date, inSameDayAs: date) // Compare only the day
        }
        
        if let existingAllocation = existingAllocations.first {
            print("✅ Daily allocation already exists for \(formatToLocalDate(date))")
            return existingAllocation
        }

        let dailyAllocation = DailyAllocation(context: context)
        dailyAllocation.id = UUID()
        dailyAllocation.date = date
        dailyAllocation.allocatedAmount = allocatedAmount
        dailyAllocation.spentAmount = 0.0
        dailyAllocation.weeklyBudget = weeklyBudget

        saveContext()
        print("✅ Daily allocation added for \(formatToLocalDate(date))")
        return dailyAllocation
    }

    func fetchDailyAllocations(for weeklyBudget: WeeklyBudget) -> [DailyAllocation] {
        let fetchRequest: NSFetchRequest<DailyAllocation> = DailyAllocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weeklyBudget == %@", weeklyBudget)
        
        do {
            _ = weeklyBudget.dailyAllocations
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching daily allocations for week \(formatToLocalDate(weeklyBudget.weekStartDate)) - \(formatToLocalDate(weeklyBudget.weekEndDate)): \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchDailyAllocation(for transaction: Transaction, on specificDate: Date? = nil) -> DailyAllocation? {
        let calendar = Calendar.current
        let transactionDate = calendar.startOfDay(for: specificDate ?? transaction.date)

        let fetchRequest: NSFetchRequest<DailyAllocation> = DailyAllocation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", transactionDate as CVarArg)

        do {
            let dailyAllocations = try context.fetch(fetchRequest)
            if let dailyAllocation = dailyAllocations.first {
                print("✅ Found DailyAllocation for transaction on \(formatToLocalDate(transactionDate)). SpentAmount: \(dailyAllocation.spentAmount)")
                return dailyAllocation
            } else {
                print("❌ No matching DailyAllocation for transaction on \(formatToLocalDate(transactionDate)).")
                return nil
            }
        } catch {
            print("⚠️ Error fetching DailyAllocation for transaction on \(formatToLocalDate(transactionDate)): \(error)")
            return nil
        }
    }

    func updateDailyAllocation(dailyAllocation: DailyAllocation, spentAmount: Double?, allocatedAmount: Double?) {
        if let spentAmount = spentAmount {
            dailyAllocation.spentAmount = spentAmount
        }
        if let allocatedAmount = allocatedAmount {
            dailyAllocation.allocatedAmount = allocatedAmount
        }
        saveContext()
    }
    
    func updateDailyAllocationSpent(for dailyAllocation: DailyAllocation) {
        let calendar = Calendar.current
        let transactionDate = calendar.startOfDay(for: dailyAllocation.date)

        print("🔄 Updating DailyAllocation spent for: \(formatToLocalDate(transactionDate))")

        let transactions = fetchTransactions(date: transactionDate)
        let totalSpent = transactions.reduce(0.0) { $0 + $1.amount }

        print("💰 Found \(transactions.count) expense transactions for date \(formatToLocalDate(transactionDate)). Total spent: \(totalSpent)")

        dailyAllocation.spentAmount = totalSpent
        saveContext()
        
        updateDailyGrowth(for: dailyAllocation)
        updateWeeklyBudgetSpent(for: dailyAllocation.weeklyBudget)
        updateMonthlyBudgetSpent(for: dailyAllocation.weeklyBudget.budget)
    }
    
    func distributeBudgetAcrossWeeks(for budget: Budget) {
        guard let daysInMonth = getDaysInMonth(from: budget.monthYear), daysInMonth > 0 else {
            print("Invalid month year or days in month.")
            return
        }

        let totalBudget = budget.budgetedAmount
        let numFullWeeks = 4
        let extraDays = daysInMonth - (numFullWeeks * 7)

        let weeklyAllocation = totalBudget * 7.0 / Double(daysInMonth)
        let remainingBudget = totalBudget - (weeklyAllocation * Double(numFullWeeks))
        let extraDaysAllocation = remainingBudget

        let existingWeeklyBudgets = fetchWeeklyBudgets(for: budget)
        var existingBudgetsDict = [String: WeeklyBudget]()
        for weeklyBudget in existingWeeklyBudgets {
            let key = "\(weeklyBudget.weekStartDate)-\(weeklyBudget.weekEndDate)"
            existingBudgetsDict[key] = weeklyBudget
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Kolkata")!

        // Get the first day of the month
        guard let firstDayOfMonth = createDate(from: 1, monthYear: budget.monthYear) else {
            print("Failed to get the first day of the month.")
            return
        }

        var startDate = firstDayOfMonth
        for _ in 1...numFullWeeks {
            guard let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else { break }

            let normalizedStartDate = calendar.startOfDay(for: startDate) // 00:00:00
            let normalizedEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)! // 23:59:59

            let key = "\(normalizedStartDate)-\(normalizedEndDate)"
            let weeklyBudget: WeeklyBudget
            if let existingWeeklyBudget = existingBudgetsDict[key] {
                existingWeeklyBudget.allocatedAmount = weeklyAllocation
                weeklyBudget = existingWeeklyBudget
            } else {
                weeklyBudget = addWeeklyBudget(for: budget, weekStartDate: normalizedStartDate, weekEndDate: normalizedEndDate, allocatedAmount: weeklyAllocation)!
            }

            distributeDailyTasks(for: weeklyBudget)
            startDate = calendar.date(byAdding: .day, value: 1, to: endDate)! // Move to next week
        }

        // Handle remaining days (5th week)
        if extraDays > 0 {
            guard let endDate = calendar.date(byAdding: .day, value: extraDays - 1, to: startDate) else { return }

            let normalizedStartDate = calendar.startOfDay(for: startDate) // 00:00:00
            let normalizedEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)! // 23:59:59

            let key = "\(normalizedStartDate)-\(normalizedEndDate)"
            let weeklyBudget: WeeklyBudget
            if let existingWeeklyBudget = existingBudgetsDict[key] {
                existingWeeklyBudget.allocatedAmount = extraDaysAllocation
                weeklyBudget = existingWeeklyBudget
            } else {
                weeklyBudget = addWeeklyBudget(for: budget, weekStartDate: normalizedStartDate, weekEndDate: normalizedEndDate, allocatedAmount: extraDaysAllocation)!
            }
            distributeDailyTasks(for: weeklyBudget)
        }

        saveContext()
        print("✅ Distributed \(totalBudget) across \(numFullWeeks) full weeks and \(extraDays) extra days for \(budget.monthYear).")
    }

    func updateWeeklyAllocation(for weeklyBudget: WeeklyBudget, newAmount: Double) {
        weeklyBudget.allocatedAmount = newAmount

        // Recalculate total budget based on updated weekly allocations
        let budget = weeklyBudget.budget
        let totalAllocated = fetchWeeklyBudgets(for: budget).reduce(0.0) { $0 + $1.allocatedAmount }
        budget.budgetedAmount = totalAllocated

        saveContext()
        print("Updated weekly allocation for \(weeklyBudget.weekStartDate) - \(weeklyBudget.weekEndDate) to \(newAmount). Total monthly budget updated to \(totalAllocated).")
    }
    
    func distributeDailyTasks(for weeklyBudget: WeeklyBudget) {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: weeklyBudget.weekStartDate) // Normalize date to 00:00:00
        let endDate = calendar.startOfDay(for: weeklyBudget.weekEndDate) // Keep consistent

        print("📆 Distributing daily tasks from \(formatToLocalDate(startDate)) to \(formatToLocalDate(endDate))")

        var date = startDate
        let totalDays = calendar.dateComponents([.day], from: startDate, to: endDate).day! + 1
        let dailyAllocation = weeklyBudget.allocatedAmount / Double(totalDays)

        while date <= endDate {
            let normalizedDate = calendar.startOfDay(for: date) // Normalize to avoid time mismatches
            print("📝 Creating daily allocation for: \(formatToLocalDate(normalizedDate))")
            _ = addDailyAllocation(for: weeklyBudget, date: normalizedDate, allocatedAmount: dailyAllocation)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }

    func fetchWeeklySummary(for weeklyBudget: WeeklyBudget) -> (allocated: Double, spent: Double, remaining: Double) {
        let allocated = weeklyBudget.allocatedAmount
        let spent = weeklyBudget.spentAmount
        let remaining = allocated - spent

        print("Weekly Summary: \(formatToLocalDate(weeklyBudget.weekStartDate)) - \(formatToLocalDate(weeklyBudget.weekEndDate))")
        print("Allocated: \(allocated), Spent: \(spent), Remaining: \(remaining)")

        return (allocated, spent, remaining)
    }

    func fetchMonthlySummary(for budget: Budget) -> (allocated: Double, spent: Double, remaining: Double) {
        let weeklyBudgets = fetchWeeklyBudgets(for: budget)
        var totalAllocated = 0.0
        var totalSpent = 0.0

        print("Monthly Summary for \(budget.monthYear):")
        for weeklyBudget in weeklyBudgets {
            let allocated = weeklyBudget.allocatedAmount
            let spent = weeklyBudget.spentAmount
            totalAllocated += allocated
            totalSpent += spent
            print("- Week: \(weeklyBudget.weekStartDate.description) - \(weeklyBudget.weekEndDate.description)")
            print("  Allocated: \(allocated), Spent: \(spent)")
        }

        let totalRemaining = totalAllocated - totalSpent
        print("Total Allocated: \(totalAllocated), Total Spent: \(totalSpent), Total Remaining: \(totalRemaining)")

        return (totalAllocated, totalSpent, totalRemaining)
    }
    
    // MARK: Plant Operations
    func fetchOrCreatePlant(for budget: Budget) -> Plant {
        if let existingPlant = budget.plant {
            return existingPlant
        }

        let newPlant = Plant(context: context)
        newPlant.id = UUID()
        newPlant.stage = "Seedling"
        newPlant.totalGrowth = 0
        newPlant.budget = budget

        // Fetch default PlantSpecie
        let plantSpecieFetchRequest: NSFetchRequest<PlantSpecie> = PlantSpecie.fetchRequest()
        plantSpecieFetchRequest.predicate = NSPredicate(format: "name == %@", "Flower")
        
        if let defaultPlantSpecie = try? context.fetch(plantSpecieFetchRequest).first {
            newPlant.plantSpecie = defaultPlantSpecie
        } else {
            print("❌ Default PlantSpecie not found!")
        }

        // Fetch default Environment
        let environmentFetchRequest: NSFetchRequest<Environment> = Environment.fetchRequest()
        environmentFetchRequest.predicate = NSPredicate(format: "name == %@", "Cliff_House")
        
        if let defaultEnvironment = try? context.fetch(environmentFetchRequest).first {
            newPlant.environment = defaultEnvironment
        } else {
            print("❌ Default Environment not found!")
        }

        saveContext()
        return newPlant
    }
    
    func updateDailyGrowth(for dailyAllocation: DailyAllocation) {
        let previousGrowth = dailyAllocation.dailyGrowth
        let savings = dailyAllocation.allocatedAmount - dailyAllocation.spentAmount
        let newGrowth: Double = (savings >= 0) ? 3.0 : 0.0
        
        dailyAllocation.dailyGrowth = newGrowth
        saveContext()
        
        if let plant = dailyAllocation.weeklyBudget.budget.plant {
            let growthChange = newGrowth - previousGrowth
            plant.totalGrowth = max(0, min(100, plant.totalGrowth + Int64(growthChange)))
            updatePlantStage(for: plant)
            saveContext()
        }

        print("🌱 Daily Growth Updated: \(formatToLocalDate(dailyAllocation.date)) - Growth: \(dailyAllocation.dailyGrowth)% - Savings: \(savings)")
    }
    
    func updateWeeklyGrowth(for weeklyBudget: WeeklyBudget) {
        let previousGrowth = weeklyBudget.weeklyGrowth
        let totalSpent = weeklyBudget.spentAmount
        let totalAllocated = weeklyBudget.allocatedAmount
        let allDailyLimitsMet = fetchDailyAllocations(for: weeklyBudget).allSatisfy { $0.dailyGrowth == 3.0 }

        var newGrowth: Double = 0.0
        if totalSpent <= totalAllocated { newGrowth += 2.0 }
        if allDailyLimitsMet { newGrowth += 2.0 }

        weeklyBudget.weeklyGrowth = newGrowth
        saveContext()

        if let plant = weeklyBudget.budget.plant {
            let growthChange = newGrowth - previousGrowth
            plant.totalGrowth = max(0, min(100, plant.totalGrowth + Int64(growthChange)))
            updatePlantStage(for: plant)
            saveContext()
        }

        print("📅 Weekly Growth Updated: \(formatToLocalDate(weeklyBudget.weekStartDate)) - Growth Change: \(newGrowth - previousGrowth)%")
    }
    
    func updateMonthlyGrowth(for budget: Budget) {
        let previousMonthlyGrowth = budget.monthlyGrowth

        let totalSpent = fetchWeeklyBudgets(for: budget).reduce(0.0) { $0 + $1.spentAmount }
        let newBonus: Double = (totalSpent <= budget.budgetedAmount) ? 10.0 : 0.0

        budget.monthlyGrowth = newBonus
        saveContext()

        print("🌱 Updated Monthly Growth for \(budget.monthYear): \(budget.monthlyGrowth)%")
        
        if let plant = budget.plant {
            let monthlyGrowthChange = newBonus - previousMonthlyGrowth
            plant.totalGrowth = max(0, min(100, plant.totalGrowth + Int64(Int(monthlyGrowthChange))))
            updatePlantStage(for: plant)
            saveContext()
        }
    }
    
    func updatePlantStage(for plant: Plant) {
        let growth = plant.totalGrowth

        switch growth {
        case 0..<20:
            plant.stage = "Seedling"
        case 20..<40:
            plant.stage = "Vegetating"
        case 40..<60:
            plant.stage = "Budding"
        case 60..<80:
            plant.stage = "Flowering"
        default:
            plant.stage = "Mature"
        }

        print("🌿 Plant Updated: Growth = \(growth)% → Stage = \(plant.stage)")
    }

    
    // MARK: Helper functions
    
    func formatToLocalDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    func monthEndDate(from monthYear: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        dateFormatter.timeZone = TimeZone.current
  
        guard let date = dateFormatter.date(from: monthYear) else {
            return nil // Return nil if the string can't be parsed into a date
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
       
        if let range = calendar.range(of: .day, in: .month, for: date) {
            
            let lastDay = range.upperBound - 1
            var lastDate = calendar.date(bySetting: .day, value: lastDay, of: date)
            
            lastDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: lastDate!)
            
            return lastDate
        }
        return nil
    }
    
    func getDaysInMonth(from monthYear: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "en_IN_POSIX") // Ensure consistent parsing
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Use a fixed time zone
        guard let date = formatter.date(from: monthYear) else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Use a fixed time zone
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }
    
    func daysLeftInMonth(from monthYear: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "en_IN_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let baseDate = formatter.date(from: monthYear) else { return nil }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let today = Date()
        guard calendar.isDate(today, equalTo: baseDate, toGranularity: .month) else {
            print("The provided monthYear does not match the current month.")
            return nil
        }
        
        let totalDays = getDaysInMonth(from: monthYear) ?? 0
        let todayDay = calendar.component(.day, from: today)
        return totalDays - todayDay
    }

    func createDate(from day: Int, monthYear: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "en_IN_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let baseDate = formatter.date(from: monthYear) else {
            print("❌ Error: Failed to parse base date from monthYear: \(monthYear)")
            return nil
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let totalDays = getDaysInMonth(from: monthYear) ?? 0

        guard day > 0 && day <= totalDays else {
            print("❌ Error: Invalid day \(day) for month \(monthYear).")
            return nil
        }

        var components = calendar.dateComponents([.year, .month], from: baseDate)
        components.day = day
        let createdDate = calendar.date(from: components)

        print("📅 Created date: \(formatToLocalDate(createdDate!))")
        return createdDate
    }
}
