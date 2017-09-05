//
//  CoreDataManager.swift
//  ItemGenerator
//
//  Created by Admin on 4/4/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let sharedInstance = CoreDataManager()
    
    
    func save(dict: NSDictionary, entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = managedContext
        // 2
        let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                in: privateMOC)!
        if(entityName == "Item"){
            let item = NSManagedObject(entity: entity,
                                       insertInto: privateMOC)
            
            // 3
            item.setValue(dict.object(forKey: "itemName"), forKeyPath: "itemName")
            item.setValue(dict.object(forKey: "itemNo"), forKey: "itemNo")
            item.setValue(dict.object(forKey: "flavorText"), forKey: "flavorText")
            item.setValue(dict.object(forKey: "type"), forKey: "type")
            item.setValue(dict.object(forKey: "hp"), forKey: "hp")
            item.setValue(dict.object(forKey: "ap"), forKey: "ap")
            item.setValue(dict.object(forKey: "apr"), forKey: "apr")
            item.setValue(dict.object(forKey: "atk"), forKey: "atk")
            item.setValue(dict.object(forKey: "intl"), forKey: "intl")
            item.setValue(dict.object(forKey: "hit"), forKey: "hit")
            item.setValue(dict.object(forKey: "def"), forKey: "def")
            item.setValue(dict.object(forKey: "res"), forKey: "res")
            item.setValue(dict.object(forKey: "eva"), forKey: "eva")
            item.setValue(dict.object(forKey: "mov"), forKey: "mov")
            item.setValue(dict.object(forKey: "rng"), forKey: "rng")
            
            // 4
            do {
                try privateMOC.save()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        else if (entityName == "Ability"){
            let ability = NSManagedObject(entity: entity, insertInto: privateMOC)
            
            ability.setValue(dict.object(forKey: "name"), forKey: "name")
            ability.setValue(dict.object(forKey: "abilityID"), forKey: "abilityID")
            ability.setValue(dict.object(forKey: "abilityDescription"), forKey: "abilityDescription")
            ability.setValue(dict.object(forKey: "range"), forKey: "range")
            ability.setValue(dict.object(forKey: "effectPattern"), forKey: "effectPatern")
            ability.setValue(dict.object(forKey: "radius"), forKey: "radius")
            ability.setValue(dict.object(forKey: "apCost"), forKey: "apCost")
            ability.setValue(dict.object(forKey: "modifierType"), forKey: "modifierType")
            ability.setValue(dict.object(forKey: "targetType"), forKey: "targetType")
            ability.setValue(dict.object(forKey: "attackEffects"), forKey: "attackEffects")
            ability.setValue(dict.object(forKey: "levelUnlock"), forKey: "levelUnlock")
            ability.setValue(dict.object(forKey: "baseEffect"), forKey: "baseEffect")
            ability.setValue(dict.object(forKey: "ratioEffect"), forKey: "ratioEffect")
            ability.setValue(dict.object(forKey: "animationTime"), forKey: "animationTime")
            ability.setValue(dict.object(forKey: "damageAtTimeForPercentage"), forKey: "damageAtTimeForPercentage")
            do {
                try privateMOC.save()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func load()-> Array<Any>{
        var items = Array<Any>()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return items
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = managedContext
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        //3
        do {
            items = try privateMOC.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return items
    }
    
    func deleteAllDataForEntity(entityName: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = managedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try privateMOC.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                privateMOC.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delele all data in \(entityName) error : \(error) \(error.userInfo)")
        }
        
        do {
            try privateMOC.save()
        } catch let error as NSError {
            print("Error While Deleting All Entries for \(entityName): \(error.userInfo)")
        }
    }
    
    func updateEntity(entityName: String, dictArray: [NSDictionary]){
        //Remove the old entries
        self.deleteAllDataForEntity(entityName: entityName)
        
        //Add new entries
        for dict in dictArray{
            self.save(dict: dict, entityName: entityName)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Saving All Entries for \(entityName): \(error.userInfo)")
        }
    }
}
