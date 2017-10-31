//
//  Purge+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Purge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purge> {
        return NSFetchRequest<Purge>(entityName: "Purge");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String

}
