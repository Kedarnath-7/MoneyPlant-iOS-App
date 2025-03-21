//
//  Budget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/03/25.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var budgetedAmount: Double
    @NSManaged public var id: UUID
    @NSManaged public var isMonthFinalized: Bool
    @NSManaged public var monthEndDate: Date
    @NSManaged public var monthlyGrowth: Double
    @NSManaged public var monthYear: String
    @NSManaged public var totalExpenses: Double
    @NSManaged public var totalIncome: Double
    @NSManaged public var categoryBudgets: NSSet?
    @NSManaged public var plant: Plant?
    @NSManaged public var weeklyBudgets: NSSet

}

// MARK: Generated accessors for categoryBudgets
extension Budget {

    @objc(addCategoryBudgetsObject:)
    @NSManaged public func addToCategoryBudgets(_ value: CategoryBudget)

    @objc(removeCategoryBudgetsObject:)
    @NSManaged public func removeFromCategoryBudgets(_ value: CategoryBudget)

    @objc(addCategoryBudgets:)
    @NSManaged public func addToCategoryBudgets(_ values: NSSet)

    @objc(removeCategoryBudgets:)
    @NSManaged public func removeFromCategoryBudgets(_ values: NSSet)

}

// MARK: Generated accessors for weeklyBudgets
extension Budget {

    @objc(addWeeklyBudgetsObject:)
    @NSManaged public func addToWeeklyBudgets(_ value: WeeklyBudget)

    @objc(removeWeeklyBudgetsObject:)
    @NSManaged public func removeFromWeeklyBudgets(_ value: WeeklyBudget)

    @objc(addWeeklyBudgets:)
    @NSManaged public func addToWeeklyBudgets(_ values: NSSet)

    @objc(removeWeeklyBudgets:)
    @NSManaged public func removeFromWeeklyBudgets(_ values: NSSet)

}

extension Budget : Identifiable {

}
