//
//  CategoryBudget+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 11/02/25.
//
//

import Foundation
import CoreData


extension CategoryBudget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryBudget> {
        return NSFetchRequest<CategoryBudget>(entityName: "CategoryBudget")
    }

    @NSManaged public var budgetedAmount: Double
    @NSManaged public var id: UUID
    @NSManaged public var spentAmount: Double
    @NSManaged public var budget: Budget
    @NSManaged public var category: Category

}

extension CategoryBudget : Identifiable {

}
