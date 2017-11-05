//
//  AbilityEffectViewController.swift
//  ItemGenerator
//
//  Created by Admin on 10/1/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

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
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
