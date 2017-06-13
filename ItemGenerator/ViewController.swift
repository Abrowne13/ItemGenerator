//
//  ViewController.swift
//  ItemGenerator
//
//  Created by Admin on 4/3/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating{
    
    
    @IBOutlet weak var tableItemList: UITableView!
    
    var itemList: [NSManagedObject] = []
    var filteredItemList: [NSManagedObject] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        let fetchRequest2 = NSFetchRequest<NSDictionary>(entityName: "Item")
        
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "itemNo", ascending: true)
        
        let sortDescripts = [sortDescript]
        
        fetchRequest.sortDescriptors = sortDescripts
        fetchRequest2.sortDescriptors = sortDescripts
        fetchRequest2.resultType = NSFetchRequestResultType.dictionaryResultType
        
        var itemDicts: [NSDictionary] = []
        
        //3
        do {
            itemList = try managedContext.fetch(fetchRequest)
            //Put this fetch in sync button
            itemDicts = try managedContext.fetch(fetchRequest2)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableItemList.reloadData()
        
        //IsValidJSONObject seems to be always false
        do{
            let data = try! JSONSerialization.data(withJSONObject: itemDicts, options: [])

            //Lots of time spent looking for this line! Prints raw json
            //let rawJSON = String(data: data, encoding: String.Encoding.utf8)
            //print(rawJSON as Any)
            
            //Prints object description
            let decoded = try JSONSerialization.jsonObject(with: data, options: [])
            //print(decoded)
            
            //Explicit casting as an array of dictionaries
            if let dictFromJSON = decoded as? [NSDictionary]{
                print(dictFromJSON)
            }
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Item List"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        //searchController.searchBar.scopeButtonTitles = ["All,Weapon,Accsry,Consume"]
        //searchController.searchBar.showsScopeBar = true
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
        tableItemList.tableHeaderView = searchController.searchBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Scope bar is not working, add ,scope: scope to try again
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        self.filterContentForSearchText(searchText:searchController.searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchBar.showsScopeBar = true
        //searchBar.sizeToFit()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        var predicate: NSPredicate
        var itemType: NSString
        if(scope == "All")
        {
            predicate = NSPredicate(format:"itemName contains[c] %@ or flavorText contains[c] %@",searchText,searchText)
        }
            
            //A bit more complicated than this... ["Weapon,Accsry,Consume,"]
        else{
            if(scope == "Accsry"){
                itemType = "Accessory"
            }
            else if(scope == "Consume"){
                itemType = "Consumable"
            }
            else{
                itemType = "Pizza"
            }
            
            
            predicate = NSPredicate(format:"itemName contains[c] %@ or flavorText contains[c] %@ and type == %@",searchText,searchText,itemType)
        }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        //2
        fetchRequest.predicate = predicate
        
        //3
        do {
            filteredItemList = try managedContext.fetch(fetchRequest)
            
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableItemList.reloadData()
    }
    
    //Table View Delegate calls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItemList.count
        }
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetail : ItemDetailViewController = self.storyboard!.instantiateViewController(withIdentifier:"itemDetail") as! ItemDetailViewController
        //The item list and the selected table cell row will likely desync
        itemDetail.item = itemList[indexPath.row] as? Item
        self.navigationController!.pushViewController(itemDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        
        guard var item = itemList[indexPath.row] as? Item else{
            return tableCell
        }
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = (filteredItemList[indexPath.row] as? Item)!
        }
        
        guard let _: String = item.value(forKey: "itemName") as! String?, item.value(forKey: "itemName") as! String? != "" else{
            print("it's actually nil!")
            return tableCell
        }
        tableCell.item = item
        tableCell.setLabelsWithItem()
        tableCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        tableCell.viewItemColor.backgroundColor = self.getItemColor(item: item)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let item = self.itemList[indexPath.row]
            
            managedContext.delete(item)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Item: \(error.userInfo)")
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            
            do {
                self.itemList = try managedContext.fetch(fetchRequest) as! [Item]
            } catch let error as NSError {
                print("Error While Fetching Data From DB: \(error.userInfo)")
            }
            
            self.tableItemList.reloadData()
            
        }
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func getItemColor(item:Item)-> UIColor{
        //Not including ap,apr,mov, and rng since they have different scaling
        let stats = ["hp","atk","intl","hit","def","res","eva"]
        var highestStatValue:Int = 0
        var highestStat: String = ""
        for stat in stats {
            let tmp = item.value(forKey: stat) as! Int
            if (tmp > highestStatValue){
                highestStatValue = tmp
                highestStat = stat
            }
        }
        
        switch highestStat {
        case "hp":
            return UIColor.green
        case "atk":
            return UIColor.red
        case "intl":
            return UIColor.orange
        case "hit":
            return UIColor.gray
        case "def":
            return UIColor.blue
        case "res":
            return UIColor.purple
        case "eva":
            return UIColor.black
        default:
            return UIColor.white
        }
    }
    
}
