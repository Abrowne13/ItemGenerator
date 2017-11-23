//
//  Critical+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Critical {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Critical> {
        return NSFetchRequest<Critical>(entityName: "Critical");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var percentModifier: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
