//
//  StealItem+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension StealItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StealItem> {
        return NSFetchRequest<StealItem>(entityName: "StealItem");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
