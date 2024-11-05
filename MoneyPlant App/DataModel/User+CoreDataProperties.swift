//
//  User+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var profileImage: Data?
    @NSManaged public var achievements: NSSet?
    @NSManaged public var budgets: Budget?
    @NSManaged public var histories: NSSet?
    @NSManaged public var notifications: NSSet?

}

// MARK: Generated accessors for achievements
extension User {

    @objc(addAchievementsObject:)
    @NSManaged public func addToAchievements(_ value: Achievement)

    @objc(removeAchievementsObject:)
    @NSManaged public func removeFromAchievements(_ value: Achievement)

    @objc(addAchievements:)
    @NSManaged public func addToAchievements(_ values: NSSet)

    @objc(removeAchievements:)
    @NSManaged public func removeFromAchievements(_ values: NSSet)

}

// MARK: Generated accessors for histories
extension User {

    @objc(addHistoriesObject:)
    @NSManaged public func addToHistories(_ value: History)

    @objc(removeHistoriesObject:)
    @NSManaged public func removeFromHistories(_ value: History)

    @objc(addHistories:)
    @NSManaged public func addToHistories(_ values: NSSet)

    @objc(removeHistories:)
    @NSManaged public func removeFromHistories(_ values: NSSet)

}

// MARK: Generated accessors for notifications
extension User {

    @objc(addNotificationsObject:)
    @NSManaged public func addToNotifications(_ value: Notification)

    @objc(removeNotificationsObject:)
    @NSManaged public func removeFromNotifications(_ value: Notification)

    @objc(addNotifications:)
    @NSManaged public func addToNotifications(_ values: NSSet)

    @objc(removeNotifications:)
    @NSManaged public func removeFromNotifications(_ values: NSSet)

}

extension User : Identifiable {

}
