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
    
    
    @IBOutlet weak var pullBtn: UIBarButtonItem!
    
    @IBOutlet weak var pushBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableItemList: UITableView!
    
    var itemList: [NSManagedObject] = []
    var filteredItemList: [NSManagedObject] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
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
    
    
    @IBAction func onPullButtonAction(_ sender: Any) {
        
        self.pullBtn.isEnabled = false
        self.pushBtn.isEnabled = false
        var baseUrlString: String = ""
        var getItemUrlString: String = ""
        
        //Pull from userDefaults
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "baseUrl") != nil){
            baseUrlString = defaults.string(forKey: "baseUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "baseUrl")
            return
        }
        
        if (defaults.string(forKey: "getItemUrl") != nil){
            getItemUrlString = defaults.string(forKey: "getItemUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "getItemUrl")
            return
        }
        
        
        let url = URL(string: baseUrlString + getItemUrlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            print(response!)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            })
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Pull failed", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert,animated:false,completion:nil)
            } else {
                if let usableData = data {
                    let itemJSON = try! JSONSerialization.jsonObject(with: usableData, options: [])
                    if let dictFromJSON = itemJSON as? [NSDictionary]{
                        //Write save function here
                        let cdManager = CoreDataManager()
                        cdManager.updateEntity(entityName: "Item", dictArray: dictFromJSON)
                        self.refreshData()
                        print("Pulled")
                    }
                }
                let alert = UIAlertController(title: "Pull succeded", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert,animated:false,completion:nil)
            }
            self.pullBtn.isEnabled = true
            self.pushBtn.isEnabled = true
        }
        task.resume()
    }
    
    @IBAction func onPushButtonAction(_ sender: Any) {
        
        self.pushBtn.isEnabled = false
        self.pullBtn.isEnabled = false
        
        var postItemUrlString: String = ""
        var baseUrlString: String = ""
        var username: String = ""
        var password: String = ""
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "postItemUrl") == nil){
            self.promptUrlFillInForString(urlString: "postItemUrl")
            return
        }
        else{
            postItemUrlString = defaults.string(forKey: "postItemUrl")!
        }
        
        if (defaults.string(forKey: "baseUrl") != nil){
            baseUrlString = defaults.string(forKey: "baseUrl")!
            
        }
        else{
            self.promptUrlFillInForString(urlString: "baseUrl")
            return
        }
        
        if ((defaults.string(forKey: "username") != nil) || (defaults.string(forKey: "password") == nil)){
            username = defaults.string(forKey: "username")!
            password = defaults.string(forKey: "password")!
        }
        else{
            self.promptAuth()
            return
        }
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "itemNo", ascending: true)
        let sortDescripts = [sortDescript]
        let fetchRequest2 = NSFetchRequest<NSDictionary>(entityName: "Item")
        fetchRequest2.sortDescriptors = sortDescripts
        fetchRequest2.resultType = NSFetchRequestResultType.dictionaryResultType
        
        var itemDicts: [NSDictionary] = []
        
        //3
        do {
            itemDicts = try managedContext.fetch(fetchRequest2)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        let data = try! JSONSerialization.data(withJSONObject: itemDicts, options: [])
        
        //Lots of time spent looking for this line! Prints raw json, unescaped....
        //let rawJSON = String(data: data, encoding: String.Encoding.utf8)
        //print(rawJSON as Any)
        
        let url = NSURL(string: baseUrlString + postItemUrlString)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data;
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            })
            if error != nil{
                print(error as Any)
                let alert = UIAlertController(title: "Push failed", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert,animated:false,completion:nil)
                return
            }
            let alert = UIAlertController(title: "Push succeded", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(okAction)
            self.present(alert,animated:false,completion:nil)
            
            print(response as Any)
            
            self.pushBtn.isEnabled = true
            self.pullBtn.isEnabled = true
            
        }
        
        task.resume()
        
    }
    
    func refreshData(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "itemNo", ascending: true)
        
        let sortDescripts = [sortDescript]
        
        fetchRequest.sortDescriptors = sortDescripts
        
        //3
        do {
            itemList = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableItemList.reloadData()
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
    
    func promptUrlFillInForString(urlString:String){
        var urlAlert:UIAlertController
        let defaults = UserDefaults.standard
        
        urlAlert = UIAlertController(title: "Missing Base Url", message: "Enter Base Url", preferredStyle: UIAlertControllerStyle.alert)
        
        if (urlString == "baseUrl" || (defaults.string(forKey: "baseUrl")?.isEmpty)!){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Base Url"
            }
        }
        if (urlString == "baseUrl" || urlString == "getItemUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "getItem Url Extenstion"
            }
        }
        if (urlString == "baseUrl" || urlString == "postItemUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "postItem Url Extenstion"
            }
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            if (urlString == "baseUrl"){
                let baseUrlTextField = urlAlert.textFields![0] as UITextField
                if (baseUrlTextField.text != nil){
                    defaults.set(baseUrlTextField.text, forKey: "baseUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "getItemUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 1
                }
                let getItemTextField = urlAlert.textFields![index] as UITextField
                if (getItemTextField.text != nil){
                    defaults.set(getItemTextField.text, forKey: "getItemUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "postItemUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 2
                }
                
                let postItemTextField = urlAlert.textFields![index] as UITextField
                if (postItemTextField.text != nil){
                    defaults.set(postItemTextField.text, forKey: "postItemUrl")
                }
            }
            
            defaults.synchronize()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            
        })
        
        urlAlert.addAction(cancelAction)
        urlAlert.addAction(saveAction)
        
        self.present(urlAlert, animated: false, completion: {
            return
        })
    }
    
    func promptAuth(){
        let defaults = UserDefaults.standard
        let authAlert = UIAlertController(title: "Enter Credentials", message: "Enter username and password", preferredStyle: UIAlertControllerStyle.alert)
        
        authAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "username"
        }
        
        authAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "password"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            let userNameTextField = authAlert.textFields![0] as UITextField
            if (userNameTextField.text != nil){
                defaults.set(userNameTextField.text, forKey: "username")
            }
            
            let passwordTextField = authAlert.textFields![1] as UITextField
            if (passwordTextField.text != nil){
                defaults.set(passwordTextField.text, forKey: "password")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: { (UIAlertAction) in
            
        })
        
        authAlert.addAction(cancelAction)
        authAlert.addAction(saveAction)
        
        self.present(authAlert, animated: false) {
            return
        }
    }
    
    func getItemColor(item:Item)-> UIColor{
        //Not including apr, mov, and rng since they have different scaling.
        //Ap is added but will largely be ignored outside of consumable items.
        let stats = ["hp","ap","atk","intl","hit","def","res","eva"]
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
        case "ap":
            return UIColor.blue
        case "atk":
            return UIColor.red
        case "intl":
            return UIColor.orange
        case "hit":
            return UIColor.gray
        case "def":
            return UIColor.lightGray
        case "res":
            return UIColor.purple
        case "eva":
            return UIColor.black
        default:
            return UIColor.white
        }
    }
    
}
