//
//  DefensePiercing+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension DefensePiercing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefensePiercing> {
        return NSFetchRequest<DefensePiercing>(entityName: "DefensePiercing");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountPierced: Int16
    @NSManaged public var percentagePierced: Float
    @NSManaged public var name: String

}
