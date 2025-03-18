//
//  UserAccount+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/03/25.
//
//

import Foundation
import CoreData


extension UserAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAccount> {
        return NSFetchRequest<UserAccount>(entityName: "UserAccount")
    }

    @NSManaged public var email: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var onBoardingRequired: Bool
    @NSManaged public var plantCoins: Int64
    @NSManaged public var transactions: Transaction?

}

extension UserAccount : Identifiable {

}
