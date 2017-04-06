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
    
    
    func save(itemDict: Dictionary<String,Any>) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Item",
                                       in: managedContext)!
        
        //let person = NSManagedObject(entity: entity,
                                     //insertInto: managedContext)
        
        // 3
        //person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            //people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return items
    }
}
