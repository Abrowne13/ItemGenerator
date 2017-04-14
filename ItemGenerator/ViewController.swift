//
//  ViewController.swift
//  ItemGenerator
//
//  Created by Admin on 4/3/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var tableItemList: UITableView!
    @IBOutlet weak var searchBarItemList: UISearchBar!
    
    var itemList: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        //3
        do {
            itemList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableItemList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Item List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Search Bar Delegate calls
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarItemList.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarItemList.showsCancelButton = false
        searchBar.resignFirstResponder();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
    }
    
    //Table View Delegate calls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        guard let item = itemList[indexPath.row] as? Item else{
            return tableCell
        }
        
        guard let _: String = item.value(forKey: "itemName") as! String?, item.value(forKey: "itemName") as! String? != "" else{
            print("it's actually nil!")
            return tableCell
        }
        tableCell.item = item
        tableCell.setLabelsWithItem()
        tableCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //Add delete action here
            print("more button tapped")
        }
        more.backgroundColor = UIColor.red
        
        return [more]
    }


}

