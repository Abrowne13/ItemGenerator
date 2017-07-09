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
    
    
    func save(itemDict: NSDictionary, entityName: String) {
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
            item.setValue(itemDict.object(forKey: "itemName"), forKeyPath: "itemName")
            item.setValue(itemDict.object(forKey: "itemNo"), forKey: "itemNo")
            item.setValue(itemDict.object(forKey: "flavorText"), forKey: "flavorText")
            item.setValue(itemDict.object(forKey: "type"), forKey: "type")
            item.setValue(itemDict.object(forKey: "hp"), forKey: "hp")
            item.setValue(itemDict.object(forKey: "ap"), forKey: "ap")
            item.setValue(itemDict.object(forKey: "apr"), forKey: "apr")
            item.setValue(itemDict.object(forKey: "atk"), forKey: "atk")
            item.setValue(itemDict.object(forKey: "intl"), forKey: "intl")
            item.setValue(itemDict.object(forKey: "hit"), forKey: "hit")
            item.setValue(itemDict.object(forKey: "def"), forKey: "def")
            item.setValue(itemDict.object(forKey: "res"), forKey: "res")
            item.setValue(itemDict.object(forKey: "eva"), forKey: "eva")
            item.setValue(itemDict.object(forKey: "mov"), forKey: "mov")
            item.setValue(itemDict.object(forKey: "rng"), forKey: "rng")
            
            // 4
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
            print("Detele all data in \(entityName) error : \(error) \(error.userInfo)")
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
            self.save(itemDict: dict, entityName: entityName)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = managedContext
        do {
            try privateMOC.save()
        } catch let error as NSError {
            print("Error While Saving All Entries for \(entityName): \(error.userInfo)")
        }
    }
}
