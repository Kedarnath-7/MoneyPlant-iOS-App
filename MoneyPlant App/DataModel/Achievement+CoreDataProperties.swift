//
//  Achievement+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension Achievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Achievement> {
        return NSFetchRequest<Achievement>(entityName: "Achievement")
    }

    @NSManaged public var title: String?
    @NSManaged public var dateEarned: Date?
    @NSManaged public var descriptionAchievement: String?
    @NSManaged public var user: User?

}

extension Achievement : Identifiable {

}
