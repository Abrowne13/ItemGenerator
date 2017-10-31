//
//  StealMoney+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension StealMoney {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StealMoney> {
        return NSFetchRequest<StealMoney>(entityName: "StealMoney");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountStolen: Int16
    @NSManaged public var amountPerDamage: Float
    @NSManaged public var name: String

}
