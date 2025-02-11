//
//  WeeklyBudget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 11/02/25.
//
//

import Foundation
import CoreData


extension WeeklyBudget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyBudget> {
        return NSFetchRequest<WeeklyBudget>(entityName: "WeeklyBudget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var allocatedAmount: Double
    @NSManaged public var isWeekFinalized: Bool
    @NSManaged public var spentAmount: Double
    @NSManaged public var weekEndDate: Date
    @NSManaged public var weeklyGrowth: Double
    @NSManaged public var weekStartDate: Date
    @NSManaged public var dailyAllocations: NSSet
    @NSManaged public var budget: Budget

}

// MARK: Generated accessors for dailyAllocations
extension WeeklyBudget {

    @objc(addDailyAllocationsObject:)
    @NSManaged public func addToDailyAllocations(_ value: DailyAllocation)

    @objc(removeDailyAllocationsObject:)
    @NSManaged public func removeFromDailyAllocations(_ value: DailyAllocation)

    @objc(addDailyAllocations:)
    @NSManaged public func addToDailyAllocations(_ values: NSSet)

    @objc(removeDailyAllocations:)
    @NSManaged public func removeFromDailyAllocations(_ values: NSSet)

}

extension WeeklyBudget : Identifiable {

}
