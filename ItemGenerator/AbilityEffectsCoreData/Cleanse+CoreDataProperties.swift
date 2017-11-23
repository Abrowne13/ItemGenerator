//
//  Cleanse+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Cleanse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cleanse> {
        return NSFetchRequest<Cleanse>(entityName: "Cleanse");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?
}
