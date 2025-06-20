//
//  Transaction+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 01/06/25.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var note: String?
    @NSManaged public var paidTo: String
    @NSManaged public var paymentMethod: String?
    @NSManaged public var type: String
    @NSManaged public var recurrence: String
    @NSManaged public var parentTransactionID: UUID?
    @NSManaged public var account: UserAccount?
    @NSManaged public var category: Category

}

extension Transaction : Identifiable {

}
