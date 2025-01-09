//
//  DailyTarget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 10/01/25.
//
//

import Foundation
import CoreData


extension DailyTarget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTarget> {
        return NSFetchRequest<DailyTarget>(entityName: "DailyTarget")
    }

    @NSManaged public var actualExpense: Double
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var savingsAchieved: Double
    @NSManaged public var targetExpense: Double
    @NSManaged public var budget: Budget?

}

extension DailyTarget : Identifiable {

}
