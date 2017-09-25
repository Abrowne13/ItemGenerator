//
//  AbilityDetailTableViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/23/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var ability: Ability!
    var abilityCellArray: NSMutableArray!
    var attackEffects: NSArray!
    var effectPattern: NSArray!
    var damageAnimations: NSArray!
    var isAttackEffectExpanded = false;
    var isEffectPatternExpanded = false;
    var isDTPExpanded = false;
    
    @IBOutlet weak var abilityDetailTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        abilityCellArray = self.getAbilityCellArray()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attackEffects = ability.attackEffects as? NSArray
        effectPattern = ability.effectPattern as? NSArray
        damageAnimations = ability.damageAtTimeForPercentage as? NSArray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        var numRows = 15
        
        if (isAttackEffectExpanded) {
            numRows += attackEffects.count
        }
        if (isEffectPatternExpanded) {
            numRows += effectPattern.count
        }
        if (isDTPExpanded) {
            numRows += damageAnimations.count
        }
        return numRows
 */
        return abilityCellArray.count
    }
    /*
 func numberOfSections(in tableView: UITableView) -> Int{
 return 15
 }
 
 func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 return 30
 }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        switch section {
        case 0:
            headerView.textLabel?.text = ability.name
        case 1:
            headerView.textLabel?.text = "Ability ID: " + String(ability.abilityID)
        case 2:
            headerView.textLabel?.text = "Modifier Type: " + ability.modifierType!
        case 3:
            headerView.textLabel?.text = "Ability Description: " + ability.abilityDescription!
        case 4:
            headerView.textLabel?.text = "Target Type: " + ability.targetType!
        case 5:
            headerView.textLabel?.text = "Level Unlock: " + String(ability.levelUnlock)
        case 6:
            headerView.textLabel?.text = "AP Cost: " + String(ability.apCost)
        case 7:
            headerView.textLabel?.text = "Base Effect: " + String(ability.apCost)
        case 8:
            headerView.textLabel?.text = "Ratio Effect: " + String(ability.ratioEffect)
        case 9:
            headerView.textLabel?.text = "Attack Effects: " + String(attackEffects.count)
        case 10:
            headerView.textLabel?.text = "Range: " + String(ability.range)
        case 11:
            headerView.textLabel?.text = "Radius: " + String(ability.radius)
        case 12:
            headerView.textLabel?.text = "Effect Pattern: " + String(effectPattern.count)
        case 13:
            headerView.textLabel?.text = "Animation Time: " + String(ability.animationTime)
        case 14:
            headerView.textLabel?.text = "Damage at Time for Percentage: " + String(damageAnimations.count)
        default: break
            
        }
        return headerView
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.cellForRow(at: indexPath)
        let cellDict = abilityCellArray[indexPath.row]
        let expandbleString = (cellDict as! NSDictionary).object(forKey:"expandable") as! String?
        if (expandbleString == "attackEffect") {
            isAttackEffectExpanded = !isAttackEffectExpanded
            abilityCellArray = self.getAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "effectPattern") {
            isEffectPatternExpanded = !isEffectPatternExpanded
            abilityCellArray = self.getAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "damageAnimation") {
            isDTPExpanded = !isDTPExpanded
            abilityCellArray = self.getAbilityCellArray()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityDetailCell")!
        let cellDict = abilityCellArray.object(at: indexPath.row) as? NSDictionary
        tableCell.textLabel?.text = cellDict?.object(forKey: "title") as! String?
        
        return tableCell
    }

    //Need to use dictionaries to add isExpandable property for all indexes
    func getAbilityCellArray() -> NSMutableArray{
        let cellArray = NSMutableArray()
        cellArray.add(["title":ability.name!])
        cellArray.add(["title":"Ability ID: " + String(ability.abilityID)])
        cellArray.add(["title":"Modifier Type: " + ability.modifierType!])
        cellArray.add(["title":"Ability Description: " + ability.abilityDescription!])
        cellArray.add(["title":"Target Type: " + ability.targetType!])
        cellArray.add(["title":"Level Unlock: " + String(ability.levelUnlock)])
        cellArray.add(["title":"AP Cost: " + String(ability.apCost)])
        cellArray.add(["title":"Base Effect: " + String(ability.apCost)])
        cellArray.add(["title":"Ratio Effect: " + String(ability.ratioEffect)])
        var attackEffectCountString = "0"
        if(attackEffects != nil){
            attackEffectCountString = String(attackEffects.count)
        }
        cellArray.add(["title":"Attack Effects: " + attackEffectCountString,"expandable":"attackEffect"])
        if (isAttackEffectExpanded){
            for dict in attackEffects{
                cellArray.add(["title":(dict as! NSDictionary).object(forKey:"name")!])
            }
            cellArray.add(["title":"Add Attack Effect"])
        }
        cellArray.add(["title":"Range: " + String(ability.range)])
        cellArray.add(["title":"Radius: " + String(ability.radius)])
        var effectPatternCountString = "0"
        if(effectPattern != nil){
            effectPatternCountString = String(effectPattern.count)
        }
        cellArray.add(["title":"Effect Pattern: " + effectPatternCountString,"expandable":"effectPattern"])
        if (isEffectPatternExpanded){
            for dict in effectPattern{
                cellArray.add(["title":(dict as! NSDictionary).object(forKey:"coordinate")!])
            }
            cellArray.add(["title":"Add Effect Pattern Postion"])
        }
        cellArray.add(["title":"Animation Time: " + String(ability.animationTime)])
        var dtpCountString = "0"
        if(damageAnimations != nil){
            dtpCountString = String(damageAnimations.count)
        }
        cellArray.add(["title":"Damage at Time for Percentage: " + dtpCountString,"expandable":"damageAnimation"])
        if (isDTPExpanded){
            for dict in damageAnimations{
                cellArray.add(["title":(dict as! NSDictionary).object(forKey:"stringValue")!])
            }
            cellArray.add(["title":"Add Percent Damage at Time"])
        }
        
        return cellArray
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
