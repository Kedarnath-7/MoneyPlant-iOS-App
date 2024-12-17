//
//  Expense+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 17/12/24.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?

}

extension Expense : Identifiable {

}
