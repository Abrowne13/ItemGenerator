//
//  Interrupt+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Interrupt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Interrupt> {
        return NSFetchRequest<Interrupt>(entityName: "Interrupt");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String

}
