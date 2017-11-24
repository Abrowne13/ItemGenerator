//
//  AbilityEffectViewController.swift
//  ItemGenerator
//
//  Created by Admin on 10/1/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class AbilityEffectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var abilityEffectTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ability Effect List"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table View Delegate calls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ability.AbilityEffects.AbilityEffectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityEffectCell") as UITableViewCell!
        tableCell.textLabel?.text = Ability.AbilityEffects.AbilityEffectsArray[indexPath.row]
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "AbilityEffectDetail") as! AbilityEffectDetailViewController
        detailVC.abilityEffectName = Ability.AbilityEffects.AbilityEffectsArray[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    @IBAction func onPullAction(_ sender: Any) {
        var baseUrlString: String = ""
        var getAbilityEffectUrlString: String = ""
        
        //Pull from userDefaults
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "baseUrl") != nil){
            baseUrlString = defaults.string(forKey: "baseUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "baseUrl")
            return
        }
        if (defaults.string(forKey: "getAbilityEffectUrl") != nil){
            getAbilityEffectUrlString = defaults.string(forKey: "getAbilityEffectUrl")!
        }
        else{
            self.promptUrlFillInForString(urlString: "getAbilityEffectUrl")
            return
        }
        
        
        let url = URL(string: baseUrlString + getAbilityEffectUrlString)
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
                    //let rawData = String(data: data!, encoding: String.Encoding.utf8)
                    //print(rawData as Any)
                    let itemJSON = try! JSONSerialization.jsonObject(with: usableData, options: [])
                    if let dictFromJSON = itemJSON as? [NSDictionary]{
                        //Write save function here
                        let cdManager = CoreDataManager()
                        cdManager.updateEntity(entityName: "AbilityEffect", dictArray: dictFromJSON)
                        print("Pulled")
                    }
                }
                let alert = UIAlertController(title: "Pull succeded", message: error as! String?, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(okAction)
                self.present(alert,animated:false,completion:nil)
            }
        }
        task.resume()
    }
    
    
    @IBAction func onPushAction(_ sender: Any) {
        var allEntryArray = [NSDictionary]()
        
        var postAbilityEffectUrlString: String = ""
        var baseUrlString: String = ""
        var username: String = ""
        var password: String = ""
        let defaults = UserDefaults.standard
        
        if (defaults.string(forKey: "postAbilityEffectUrl") == nil){
            self.promptUrlFillInForString(urlString: "postAbilityEffectUrl")
            return
        }
        else{
            postAbilityEffectUrlString = defaults.string(forKey: "postAbilityEffectUrl")!
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
        
        for entityName in Ability.AbilityEffects.AbilityEffectsArray{
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let fetchRequest2 = NSFetchRequest<NSDictionary>(entityName: entityName)
            fetchRequest2.resultType = NSFetchRequestResultType.dictionaryResultType
            
            //3
            do {
                allEntryArray += try managedContext.fetch(fetchRequest2)
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        let data = try! JSONSerialization.data(withJSONObject: allEntryArray, options: [])
        
        //Lots of time spent looking for this line! Prints raw json, but escaped....
        let rawJSON = String(data: data, encoding: String.Encoding.utf8)
        print(rawJSON as Any)
        
        let url = NSURL(string: baseUrlString + postAbilityEffectUrlString)
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
        }
        
        task.resume()
    }

    //MARK: Authentication method which should live elsewhere
    
    func promptUrlFillInForString(urlString:String){
        var urlAlert:UIAlertController
        let defaults = UserDefaults.standard
        
        urlAlert = UIAlertController(title: "Missing Url", message: "Enter Url", preferredStyle: UIAlertControllerStyle.alert)
        
        if (urlString == "baseUrl" || (defaults.string(forKey: "baseUrl")?.isEmpty)!){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Base Url"
            }
        }
        if (urlString == "baseUrl" || urlString == "getAbilityEffectUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "getAbilityEffect Url Extenstion"
            }
        }
        if (urlString == "baseUrl" || urlString == "postAbilityEffectUrl"){
            urlAlert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "postAbilityEffect Url Extenstion"
            }
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            if (urlString == "baseUrl"){
                let baseUrlTextField = urlAlert.textFields![0] as UITextField
                if (baseUrlTextField.text != nil){
                    defaults.set(baseUrlTextField.text, forKey: "baseUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "getAbilityEffectUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 1
                }
                let getAbilityEffectTextField = urlAlert.textFields![index] as UITextField
                if (getAbilityEffectTextField.text != nil){
                    defaults.set(getAbilityEffectTextField.text, forKey: "getAbilityEffectUrl")
                }
            }
            
            if (urlString == "baseUrl" || urlString == "postAbilityEffectUrl"){
                var index: Int = 0
                if(urlString == "baseUrl"){
                    index = 2
                }
                
                let postAbilityEffectTextField = urlAlert.textFields![index] as UITextField
                if (postAbilityEffectTextField.text != nil){
                    defaults.set(postAbilityEffectTextField.text, forKey: "postAbilityEffectUrl")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
