//
//  Reward+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension Reward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reward> {
        return NSFetchRequest<Reward>(entityName: "Reward")
    }

    @NSManaged public var rewardName: String?
    @NSManaged public var pointsRequired: Int32
    @NSManaged public var isRedeemed: Bool

}

extension Reward : Identifiable {

}
