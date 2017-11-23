//
//  Protection+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Protection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Protection> {
        return NSFetchRequest<Protection>(entityName: "Protection");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var turnDuration: Int16
    @NSManaged public var statProtected: String?
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
