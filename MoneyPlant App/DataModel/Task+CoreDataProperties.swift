//
//  Task+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dateAssigned: Date?
    @NSManaged public var descriptionTask: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var rewardPoints: Int32
    @NSManaged public var budget: Budget?

}

extension Task : Identifiable {

}
