//
//  LifeLoss+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension LifeLoss {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LifeLoss> {
        return NSFetchRequest<LifeLoss>(entityName: "LifeLoss");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountLoss: Int32
    @NSManaged public var percentLoss: Float
    @NSManaged public var amountPerDamage: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
