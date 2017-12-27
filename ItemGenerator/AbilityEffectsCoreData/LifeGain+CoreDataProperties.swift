//
//  LifeGain+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension LifeGain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LifeGain> {
        return NSFetchRequest<LifeGain>(entityName: "LifeGain");
    }

    @NSManaged public var amountGain: Int32
    @NSManaged public var procRate: Float
    @NSManaged public var percentGain: Float
    @NSManaged public var amountPerDamage: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
