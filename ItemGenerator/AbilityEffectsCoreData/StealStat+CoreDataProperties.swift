//
//  StealStat+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension StealStat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StealStat> {
        return NSFetchRequest<StealStat>(entityName: "StealStat");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountStolen: Float
    @NSManaged public var amountPerDamage: Float
    @NSManaged public var statStolen: String?
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
