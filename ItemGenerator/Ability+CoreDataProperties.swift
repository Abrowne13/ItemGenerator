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

    struct AbilityEffects {
        //Attack Effects, all should have a proc percentage and fill those < 1
        static var DefensePiercing = "DefensePiercing"; //Amount pierced/Percentage pierced
        static var ResistPiercing = "ResistPiercing"; //Amount pierced/Percentage pierced
        static var PerfectAim = "PerfectAim"; //
        static var KillingBlow = "KillingBlow"; //
        static var Uncounterable = "Uncounterable"; //
        //Damage Modifiers
        static var PercentDamage = "PercentDamage"; //Percentage
        static var Critical = "Critical"; // Damage percentage
        static var GlancingBlow = "GlancingBlow"; //Damge percentage
        //After Effects
        static var APDamage = "APDamage"; // Amount
        static var LifeGain = "LifeGain"; // Amount/Amount per Damage/Percent per Damage
        static var LifeLoss = "LifeLoss"; // Amount/Percentage
        static var Purge = "Purge"; //      //Removes buffs debuffs (barrier, protection, invincibility, vulnerability)
        static var Cleanse = "Cleanse"; //      //Remove status effects
        static var StealItem = "StealItem"; //
        static var StealMoney = "StealMoney"; // Amount/Amount per Damage/Percentage per target
        static var StealStat = "StealStat"; // Stat, Amount/Amount per Damage/Percentage per target
        static var APGain = "APGain"; // Amount/Amount per Damage/Percentage per target
        static var Knockback = "Knockback"; // Number of spaces
        static var Barrier = "Barrier"; // Strength, duration, damageType?
        static var Interrupt = "Interrupt"; //
        static var Protection = "Protection"; // Damage type, duration
        static var Invincibility = "Invinciblity"; //Duration
        //Should be a status effect//static var Vulnerabilities = "Vulnerabilities"; // Damage type, duration
        static var ActionReset = "ActionReset";
        static var ChainAbility = "ChainAbility";
        static var StatusEffect = "StatusEffect";
        static var AbilityEffectsArray = [DefensePiercing,ResistPiercing,PerfectAim,KillingBlow,Uncounterable,PercentDamage,Critical,GlancingBlow,APDamage,LifeGain,LifeLoss,Purge,Cleanse,StealItem,StealMoney,StealStat,APGain,Knockback,Barrier,Interrupt,Protection,Invincibility,ActionReset,ChainAbility];
    }
    
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
