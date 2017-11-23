//
//  PercentDamage+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension PercentDamage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PercentDamage> {
        return NSFetchRequest<PercentDamage>(entityName: "PercentDamage");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var percentModifier: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
