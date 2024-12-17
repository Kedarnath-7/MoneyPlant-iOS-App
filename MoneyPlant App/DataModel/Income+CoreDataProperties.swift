//
//  Income+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 17/12/24.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?

}

extension Income : Identifiable {

}
