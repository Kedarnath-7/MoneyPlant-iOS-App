//
//  DailyAllocation+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/03/25.
//
//

import Foundation
import CoreData


extension DailyAllocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyAllocation> {
        return NSFetchRequest<DailyAllocation>(entityName: "DailyAllocation")
    }

    @NSManaged public var allocatedAmount: Double
    @NSManaged public var dailyGrowth: Double
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var spentAmount: Double
    @NSManaged public var weeklyBudget: WeeklyBudget
    @NSManaged public var isLocked: Bool

}

extension DailyAllocation : Identifiable {

}
