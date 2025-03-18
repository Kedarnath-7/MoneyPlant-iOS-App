//
//  PlantSpecie+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/03/25.
//
//

import Foundation
import CoreData


extension PlantSpecie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantSpecie> {
        return NSFetchRequest<PlantSpecie>(entityName: "PlantSpecie")
    }

    @NSManaged public var image: String
    @NSManaged public var isUnlocked: Bool
    @NSManaged public var name: String
    @NSManaged public var requiredCoins: Int64
    @NSManaged public var plant: NSSet?

}

// MARK: Generated accessors for plant
extension PlantSpecie {

    @objc(addPlantObject:)
    @NSManaged public func addToPlant(_ value: Plant)

    @objc(removePlantObject:)
    @NSManaged public func removeFromPlant(_ value: Plant)

    @objc(addPlant:)
    @NSManaged public func addToPlant(_ values: NSSet)

    @objc(removePlant:)
    @NSManaged public func removeFromPlant(_ values: NSSet)

}

extension PlantSpecie : Identifiable {

}
