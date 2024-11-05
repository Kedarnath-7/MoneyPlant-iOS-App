//
//  Notification+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension Notification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notification> {
        return NSFetchRequest<Notification>(entityName: "Notification")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var triggerDate: Date?
    @NSManaged public var message: String?
    @NSManaged public var user: User?

}

extension Notification : Identifiable {

}
