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
        //Damage Modifiers
        static var PercentDamage = "PercentDamage"; //Percentage
        static var Critical = "Critical"; // Damage percentage
        static var GlancingBlow = "GlancingBlow"; //Damge percentage
        static var Survive = "Survive"; //Duration
        static var Guard = "Guard"
        static var Protection = "Protection"; // Damage type, duration
        static var Invincibility = "Invincibility"; //Duration
        static var PerfectDodge = "PerfectDodge";  //Duration
        static var Barrier = "Barrier"; // Strength, duration, damageType?
        static var Interrupt = "Interrupt"; //interruptingAbility
        //After Effects
        static var APDamage = "APDamage"; // Amount
        static var LifeGain = "LifeGain"; // Amount/Amount per Damage/Percent per Damage
        static var LifeLoss = "LifeLoss"; // Amount/Percentage
        static var Purge = "Purge"; //      //Removes buffs debuffs (barrier, protection, invincibility, vulnerability)
        static var Uncounterable = "Uncounterable"; //
        static var Cleanse = "Cleanse"; //      //Remove status effects
        static var StealItem = "StealItem"; //
        static var StealMoney = "StealMoney"; // Amount/Amount per Damage/Percentage per target
        static var StealStat = "StealStat"; // Stat, Amount/Amount per Damage/Percentage per target
        static var APGain = "APGain"; // Amount/Amount per Damage/Percentage per target
        static var Knockback = "Knockback"; // Number of spaces, effectPattern
        static var Movement = "Movement"; // radius, effectPattern
        static var BlockSpace = "BlockSpace"; // duration, effectPattern
        //Should be a status effect//static var Vulnerabilities = "Vulnerabilities"; // Damage type, duration
        static var ActionReset = "ActionReset";
        static var ChainAbility = "ChainAbility"; //chainingAbility
        static var StatusEffect = "StatusEffect";
        static var AbilityEffectsArray = [DefensePiercing,ResistPiercing,PerfectAim,KillingBlow,Uncounterable,PercentDamage,Critical,GlancingBlow,APDamage,LifeGain,LifeLoss,Purge,Cleanse,StealItem,StealMoney,StealStat,APGain,Knockback,Movement,BlockSpace,Barrier,Interrupt,Guard,Protection,Invincibility,PerfectDodge,Survive,ActionReset,ChainAbility,StatusEffect];
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ability> {
        return NSFetchRequest<Ability>(entityName: "Ability");
    }

    @NSManaged public var name: String?
    @NSManaged public var abilityDescription: String?
    @NSManaged public var abilityID: Int16
    @NSManaged public var isHealing: Bool
    @NSManaged public var applyEffects: NSObject?
    @NSManaged public var casterEffects: NSObject?
    @NSManaged public var range: Int16
    @NSManaged public var effectPattern: NSObject?
    @NSManaged public var radius: Int16
    @NSManaged public var apCost: Int32
    @NSManaged public var modifierType: String?
    @NSManaged public var targetType: String?
    @NSManaged public var targetEffects: NSObject?
    @NSManaged public var levelUnlock: Int16
    @NSManaged public var baseValue: Int32
    @NSManaged public var ratioValue: Float
    @NSManaged public var animationTime: Float
    @NSManaged public var damageAtTimeForPercentage: NSObject?

}
