//
//  PlantProgress+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//
//

import Foundation
import CoreData


extension PlantProgress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantProgress> {
        return NSFetchRequest<PlantProgress>(entityName: "PlantProgress")
    }

    @NSManaged public var growthStage: Int32
    @NSManaged public var dayProgress: Int32
    @NSManaged public var monthProgress: Int32

}

extension PlantProgress : Identifiable {

}
