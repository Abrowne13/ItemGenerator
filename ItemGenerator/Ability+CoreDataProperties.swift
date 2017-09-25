//
//  Ability+CoreDataProperties.swift
//  ItemGenerator
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import Foundation
import CoreData


extension Ability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ability> {
        return NSFetchRequest<Ability>(entityName: "Ability");
    }

    @NSManaged public var name: String?
    @NSManaged public var abilityDescription: String?
    @NSManaged public var abilityID: Int16
    @NSManaged public var range: Int16
    @NSManaged public var effectPattern: NSObject?
    @NSManaged public var radius: Int16
    @NSManaged public var apCost: Int16
    @NSManaged public var modifierType: String?
    @NSManaged public var targetType: String?
    @NSManaged public var attackEffects: NSObject?
    @NSManaged public var levelUnlock: Int16
    @NSManaged public var baseEffect: Int16
    @NSManaged public var ratioEffect: Float
    @NSManaged public var animationTime: Float
    @NSManaged public var damageAtTimeForPercentage: NSObject?

}
