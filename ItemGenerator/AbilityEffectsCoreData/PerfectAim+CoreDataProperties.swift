//
//  PerfectAim+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension PerfectAim {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PerfectAim> {
        return NSFetchRequest<PerfectAim>(entityName: "PerfectAim");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String

}
