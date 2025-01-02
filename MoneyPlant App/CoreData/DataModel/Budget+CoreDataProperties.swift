//
//  Budget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/01/25.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var income: Double
    @NSManaged public var monthYear: String
    @NSManaged public var totalExpenses: Double
    @NSManaged public var budgetAmount: Double
    @NSManaged public var dailyTargets: NSSet?

}

// MARK: Generated accessors for dailyTargets
extension Budget {

    @objc(addDailyTargetsObject:)
    @NSManaged public func addToDailyTargets(_ value: DailyTarget)

    @objc(removeDailyTargetsObject:)
    @NSManaged public func removeFromDailyTargets(_ value: DailyTarget)

    @objc(addDailyTargets:)
    @NSManaged public func addToDailyTargets(_ values: NSSet)

    @objc(removeDailyTargets:)
    @NSManaged public func removeFromDailyTargets(_ values: NSSet)

}

extension Budget : Identifiable {

}
