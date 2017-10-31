//
//  GlancingBlow+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension GlancingBlow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GlancingBlow> {
        return NSFetchRequest<GlancingBlow>(entityName: "GlancingBlow");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var percentModifier: Float
    @NSManaged public var name: String

}
