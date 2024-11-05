//
//  History+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var month: Date?
    @NSManaged public var totalExpenses: Double
    @NSManaged public var totalIncome: Double
    @NSManaged public var totalSavings: Double
    @NSManaged public var expenses: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for expenses
extension History {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension History : Identifiable {

}
