//
//  AbilityListViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class AbilityListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating{
    
    
    @IBOutlet weak var pullBtn: UIBarButtonItem!
    
    @IBOutlet weak var pushBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableAbilityList: UITableView!
    
    var abilityList: [NSManagedObject] = []
    var filteredAbilityList: [NSManagedObject] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Ability List"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        //searchController.searchBar.scopeButtonTitles = ["All,Weapon,Accsry,Consume"]
        //searchController.searchBar.showsScopeBar = true
        searchController.searchBar.sizeToFit()
        
        definesPresentationContext = true
        tableAbilityList.tableHeaderView = searchController.searchBar
    }
    
    
    @IBAction func onPullAction(_ sender: Any) {
        self.pullBtn.isEnabled = false
        self.pushBtn.isEnabled = false
        var baseUrlString: String = ""
        var getAbilityUrlString: String = ""
        
        //Pull from userDefaults
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "baseUrl") != nil){
            baseUrlString = defaults.string(forKey: "baseUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "baseUrl")
            return
        }
        if (defaults.string(forKey: "getAbilityUrl") != nil){
            getAbilityUrlString = defaults.string(forKey: "getAbilityUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "getAbilityUrl")
            return
        }
        
        let url = URL(string: baseUrlString + getAbilityUrlString)
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
                    print(usableData)
                    let abilityJSON = try! JSONSerialization.jsonObject(with: usableData, options: [])
                    
                    if let dictFromJSON = abilityJSON as? [NSDictionary]{
                        //Write save function here
                        
                        let cdManager = CoreDataManager()
                        cdManager.updateEntity(entityName: "Ability", dictArray: dictFromJSON)
                        print("Pulled")
                    }
                }
                let alert = UIAlertController(title: "Pull succeded", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert,animated:false,completion:nil)
                self.refreshData()
            }
            self.pullBtn.isEnabled = true
            self.pushBtn.isEnabled = true
        }
        task.resume()

    }
    
    @IBAction func onPushAction(_ sender: Any) {
        self.pushBtn.isEnabled = false
        self.pullBtn.isEnabled = false
        
        var postAbilityUrlString: String = ""
        var baseUrlString: String = ""
        var username: String = ""
        var password: String = ""
        let defaults = UserDefaults.standard
        if (defaults.string(forKey: "postAbilityUrl") == nil){
            self.promptUrlFillInForString(urlString: "postAbilityUrl")
            return
        }
        else{
            postAbilityUrlString = defaults.string(forKey: "postAbilityUrl")!
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
        
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "abilityID", ascending: true)
        let sortDescripts = [sortDescript]
        let fetchRequest2 = NSFetchRequest<NSDictionary>(entityName: "Ability")
        fetchRequest2.sortDescriptors = sortDescripts
        fetchRequest2.resultType = NSFetchRequestResultType.dictionaryResultType
        
        var abilityDicts: [NSDictionary] = []
        
        //3
        do {
            abilityDicts = try managedContext.fetch(fetchRequest2)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        let data = try! JSONSerialization.data(withJSONObject: abilityDicts, options: [])
        
        //Lots of time spent looking for this line! Prints raw json, unescaped....
        //let rawJSON = String(data: data, encoding: String.Encoding.utf8)
        //print(rawJSON as Any)
        
        let url = NSURL(string: baseUrlString + postAbilityUrlString)
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
            NSFetchRequest<NSManagedObject>(entityName: "Ability")
        
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "abilityID", ascending: true)
        
        let sortDescripts = [sortDescript]
        
        fetchRequest.sortDescriptors = sortDescripts
        
        //3
        do {
            abilityList = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableAbilityList.reloadData()
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
        if(scope == "All")
        {
            predicate = NSPredicate(format:"name contains[c] %@ or abilityDescription contains[c] %@",searchText,searchText)
        }
            
            predicate = NSPredicate(format:"aame contains[c] %@ or flavorText contains[c] %@",searchText,searchText)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Ability")
        
        //2
        fetchRequest.predicate = predicate
        
        //3
        do {
            filteredAbilityList = try managedContext.fetch(fetchRequest)
            
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableAbilityList.reloadData()
    }
    
    //Table View Delegate calls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAbilityList.count
        }
        return abilityList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        let abilityDetail : AbilityDetailViewController = self.storyboard!.instantiateViewController(withIdentifier:"abilityDetail") as! AbilityDetailViewController
        abilityDetail.ability = abilityList[indexPath.row] as? Ability
        self.navigationController!.pushViewController(abilityDetail, animated: true)
        */
        
        let abilityDetail : AbilityDetailTableViewController = self.storyboard!.instantiateViewController(withIdentifier:"abilityDetailTableView") as! AbilityDetailTableViewController
        abilityDetail.ability = abilityList[indexPath.row] as? Ability
        self.navigationController!.pushViewController(abilityDetail, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : AbilityTableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityCell") as! AbilityTableViewCell
        
        guard var ability = abilityList[indexPath.row] as? Ability else{
            return tableCell
        }
        
        if searchController.isActive && searchController.searchBar.text != "" {
            ability = (filteredAbilityList[indexPath.row] as? Ability)!
        }
        tableCell.ability = ability
        tableCell.setLabelsWithAbility()
        tableCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        
        tableCell.viewAbilityColor.backgroundColor = self.getAbilityColor(ability: ability)
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
            
            let ability = self.abilityList[indexPath.row]
            
            managedContext.delete(ability)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Ability: \(error.userInfo)")
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ability")
            
            do {
                self.abilityList = try managedContext.fetch(fetchRequest) as! [Ability]
            } catch let error as NSError {
                print("Error While Fetching Data From DB: \(error.userInfo)")
            }
            
            self.tableAbilityList.reloadData()
            
        }
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func promptUrlFillInForString(urlString:String){
        var urlAlert:UIAlertController
        let defaults = UserDefaults.standard
        
        urlAlert = UIAlertController(title: "Missing Base Url", message: "Enter Base Url", preferredStyle: UIAlertControllerStyle.alert)
        print(urlString)
        if (urlString == "baseUrl" || (defaults.string(forKey: "baseUrl")?.isEmpty)!){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Base Url"
            }
        }
        if (urlString == "baseUrl" || urlString == "getAbilityUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "getAbility Url Extenstion"
            }
        }
        if (urlString == "baseUrl" || urlString == "postAbilityUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "postAbility Url Extenstion"
            }
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            if (urlString == "baseUrl"){
                let baseUrlTextField = urlAlert.textFields![0] as UITextField
                if (baseUrlTextField.text != nil){
                    defaults.set(baseUrlTextField.text, forKey: "baseUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "getAbilityUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 1
                }
                let getAbilityTextField = urlAlert.textFields![index] as UITextField
                if (getAbilityTextField.text != nil){
                    defaults.set(getAbilityTextField.text, forKey: "getAbilityUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "postAbilityUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 2
                }
                
                let postAbilityTextField = urlAlert.textFields![index] as UITextField
                if (postAbilityTextField.text != nil){
                    defaults.set(postAbilityTextField.text, forKey: "postAbilityUrl")
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
    
    func getAbilityColor(ability:Ability)-> UIColor{
        let modifierType = ability.modifierType!
        
        switch modifierType {
        case "ap":
            return UIColor.green
        case "hp":
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
