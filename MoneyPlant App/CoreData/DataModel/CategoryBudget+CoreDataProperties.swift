//
//  CategoryBudget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 10/01/25.
//
//

import Foundation
import CoreData


extension CategoryBudget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryBudget> {
        return NSFetchRequest<CategoryBudget>(entityName: "CategoryBudget")
    }

    @NSManaged public var id: UUID
    @NSManaged public var budgetedAmount: Double
    @NSManaged public var spentAmount: Double
    @NSManaged public var category: Category
    @NSManaged public var budget: Budget

}

extension CategoryBudget : Identifiable {

}
