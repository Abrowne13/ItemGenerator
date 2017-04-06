//
//  Item+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 4/3/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var itemNo: Int16
    @NSManaged public var itemName: String?
    @NSManaged public var flavorText: String?
    @NSManaged public var type: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var hp: Int16
    @NSManaged public var ap: Int16
    @NSManaged public var apr: Int16
    @NSManaged public var atk: Int16
    @NSManaged public var def: Int16
    @NSManaged public var intl: Int16
    @NSManaged public var res: Int16
    @NSManaged public var hit: Int16
    @NSManaged public var eva: Int16
    @NSManaged public var mov: Int16
    @NSManaged public var rng: Int16

}
