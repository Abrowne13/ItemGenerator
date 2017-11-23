//
//  ChainAbility+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension ChainAbility {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChainAbility> {
        return NSFetchRequest<ChainAbility>(entityName: "ChainAbility");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var name: String
    @NSManaged public var effectType: String?

}
