//
//  APGain+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension APGain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APGain> {
        return NSFetchRequest<APGain>(entityName: "APGain");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountGain: Int16
    @NSManaged public var percentGain: Float
    @NSManaged public var amountPerDamage: Float
    @NSManaged public var name: String

}
