//
//  KillingBlow+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension KillingBlow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KillingBlow> {
        return NSFetchRequest<KillingBlow>(entityName: "KillingBlow");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
