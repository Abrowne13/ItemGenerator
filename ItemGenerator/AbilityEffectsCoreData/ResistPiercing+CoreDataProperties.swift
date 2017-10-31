//
//  ResistPiercing+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 10/29/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension ResistPiercing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResistPiercing> {
        return NSFetchRequest<ResistPiercing>(entityName: "ResistPiercing");
    }

    @NSManaged public var procRate: Float
    @NSManaged public var amountPierced: Int16
    @NSManaged public var percentagePierced: Float
    @NSManaged public var name: String

}
