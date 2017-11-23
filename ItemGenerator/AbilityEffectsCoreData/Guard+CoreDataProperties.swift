//
//  Guard+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/31/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Guard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Guard> {
        return NSFetchRequest<Guard>(entityName: "Guard");
    }

    @NSManaged public var name: String?
    @NSManaged public var procRate: Float
    @NSManaged public var percentGuarded: Float
    @NSManaged public var amountGuarded: Int16
    @NSManaged public var effectType: String?

}
