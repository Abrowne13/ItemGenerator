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
        
    }
    
    
    @IBAction func onPushAction(_ sender: Any) {
        var allEntryArray = [NSDictionary]()
        
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
