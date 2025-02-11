//
//  Account+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 11/02/25.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var balance: Double
    @NSManaged public var id: UUID?
    @NSManaged public var initialBalance: Double
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var transactions: Transaction?

}

extension Account : Identifiable {

}
