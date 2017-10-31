//
//  Barrier+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Barrier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Barrier> {
        return NSFetchRequest<Barrier>(entityName: "Barrier");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountBarred: Int16
    @NSManaged public var statBarred: String?
    @NSManaged public var turnDuration: Int16
    @NSManaged public var name: String

}
