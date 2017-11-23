//
//  Invincibility+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Invincibility {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invincibility> {
        return NSFetchRequest<Invincibility>(entityName: "Invincibility");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var turnDuration: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
