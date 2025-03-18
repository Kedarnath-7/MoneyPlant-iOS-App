//
//  Plant+CoreDataProperties.swift
//  MoneyPlant App
//
//  Created by admin86 on 18/03/25.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var id: UUID
    @NSManaged public var stage: String
    @NSManaged public var totalGrowth: Int64
    @NSManaged public var budget: Budget
    @NSManaged public var environment: Environment
    @NSManaged public var plantSpecie: PlantSpecie

}

extension Plant : Identifiable {

}
