//
//  Knockback+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Knockback {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Knockback> {
        return NSFetchRequest<Knockback>(entityName: "Knockback");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var numberOfSpaces: Int16
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
