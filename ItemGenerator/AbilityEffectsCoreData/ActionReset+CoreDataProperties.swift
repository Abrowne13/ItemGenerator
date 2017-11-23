//
//  ActionReset+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension ActionReset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActionReset> {
        return NSFetchRequest<ActionReset>(entityName: "ActionReset");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
