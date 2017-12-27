//
//  APDamage+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension APDamage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APDamage> {
        return NSFetchRequest<APDamage>(entityName: "APDamage");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountDamage: Int32
    @NSManaged public var percentDamage: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
