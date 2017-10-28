//
//  AbilityDetailTableViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/23/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var ability: Ability!
    var abilityCellArray: NSMutableArray!
    var attackEffects: NSArray!
    var effectPattern: NSArray!
    var damageAnimations: NSArray!
    var isAttackEffectExpanded = false;
    var isEffectPatternExpanded = false;
    var isDTPExpanded = false;
    let stringKeys = ["name","modifierType","abilityDescription","targetType"]
    let intKeys = ["abilityID","levelUnlock","apCost","baseEffect","range","radius"]
    let floatKeys = ["ratioEffect","animationTime"]
    
    @IBOutlet weak var abilityDetailTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Edit Ability"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attackEffects = ability.attackEffects as? NSArray
        effectPattern = ability.effectPattern as? NSArray
        damageAnimations = ability.damageAtTimeForPercentage as? NSArray
        self.updateAbilityCellArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : AbilityDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityDetailCell") as! AbilityDetailTableViewCell
        
        tableCell.abilityDetailTextField.delegate = self
        let cellDict = abilityCellArray.object(at: indexPath.row) as? NSDictionary
        var str1 = cellDict?.object(forKey: "titleName") as! String?
        var str2 = cellDict?.object(forKey: "titleValue") as! String?
        if (str1 == nil) {
            str1 = ""
        }
        if (str2 == nil) {
            str2 = ""
        }
        tableCell.abilityDetailLabel?.text = str1! + str2!
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellDict = abilityCellArray[indexPath.row]
        let expandbleString = (cellDict as! NSDictionary).object(forKey:"expandable") as! String?
        if (expandbleString == "attackEffect") {
            isAttackEffectExpanded = !isAttackEffectExpanded
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "effectPattern") {
            isEffectPatternExpanded = !isEffectPatternExpanded
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "damageAnimation") {
            isDTPExpanded = !isDTPExpanded
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else{
            let cell = tableView.cellForRow(at: indexPath) as! AbilityDetailTableViewCell
            if (cell.abilityDetailTextField.isHidden){
                cell.abilityDetailLabel.isHidden = true
                cell.abilityDetailTextField.placeholder = cell.abilityDetailLabel.text
                cell.abilityDetailTextField.isHidden = false
            }
            else{
                cell.abilityDetailLabel.isHidden = false
                cell.abilityDetailTextField.isHidden = true
                if (cell.abilityDetailTextField.text == "") {
                    cell.abilityDetailLabel.text = cell.abilityDetailTextField.placeholder
                }
                else{
                    
                    let dict = self.abilityCellArray.object(at: indexPath.row) as! NSDictionary
                    /*
                    let mutableDict = NSMutableDictionary.init(dictionary: dict)
                    mutableDict.setValue(cell.abilityDetailTextField.text, forKey: "titleValue")
                    dict = mutableDict
                    self.abilityCellArray[indexPath.row] = dict
                     */
                    self .setTextForKey(text: cell.abilityDetailTextField.text!, key: dict.object(forKey: "abilityKey") as! String)
                    self.updateAbilityCellArray()
                    self.abilityDetailTableView.reloadData()
                    cell.abilityDetailTextField.text = ""
                }
            }
        }
    }
    
    //May want to get rid of
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dict = abilityCellArray.object(at: indexPath.row) as! NSDictionary
        return dict.allKeys.count == 1
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Edit") { action, index in
            let cell = tableView.cellForRow(at: indexPath) as! AbilityDetailTableViewCell
            
            cell.abilityDetailLabel.isHidden = true
            cell.abilityDetailTextField.isHidden = false
        }
        deleteAction.backgroundColor = UIColor.blue
        
        return [deleteAction]
    }


    func updateAbilityCellArray(){
        if(abilityCellArray != nil){
            abilityCellArray.removeAllObjects()
        }
        else{
            abilityCellArray = NSMutableArray()
        }
        abilityCellArray.add(["titleName":"Name: ","titleValue":ability.name!,"abilityKey":"name"])
        abilityCellArray.add(["titleName":"Ability ID: ","titleValue":String(ability.abilityID),"abilityKey":"abilityID"])
        abilityCellArray.add(["titleName":"Modifier Type: ","titleValue":ability.modifierType!,"abilityKey":"modifierType"])
        abilityCellArray.add(["titleName":"Ability Description: ","titleValue":ability.abilityDescription!,"abilityKey":"abilityDescription"])
        abilityCellArray.add(["titleName":"Target Type: ","titleValue":ability.targetType!,"abilityKey":"targetType"])
        abilityCellArray.add(["titleName":"Level Unlock: ","titleValue":String(ability.levelUnlock),"abilityKey":"levelUnlock"])
        abilityCellArray.add(["titleName":"AP Cost: ","titleValue":String(ability.apCost),"abilityKey":"apCost"])
        abilityCellArray.add(["titleName":"Base Effect: ","titleValue":String(ability.baseEffect),"abilityKey":"baseEffect"])
        abilityCellArray.add(["titleName":"Ratio Effect: ","titleValue":String(ability.ratioEffect),"abilityKey":"ratioEffect"])
        var attackEffectCountString = "0"
        if(attackEffects != nil){
            attackEffectCountString = String(attackEffects.count)
        }
        else{
            attackEffects = NSArray()
        }
        abilityCellArray.add(["titleName":"Attack Effects: ","titleValue":attackEffectCountString,"expandable":"attackEffect","abilityKey":"attackEffects"])
        if (isAttackEffectExpanded){
            for dict in attackEffects{
                abilityCellArray.add(["titleName":(dict as! NSDictionary).object(forKey:"name")!])
            }
            abilityCellArray.add(["titleName":"Add Attack Effect"])
        }
        abilityCellArray.add(["titleName":"Range: ","titleValue":String(ability.range),"abilityKey":"range"])
        abilityCellArray.add(["titleName":"Radius: ","titleValue":String(ability.radius),"abilityKey":"radius"])
        var effectPatternCountString = "0"
        if(effectPattern != nil){
            effectPatternCountString = String(effectPattern.count)
        }
        else{
            effectPattern = NSArray()
        }
        abilityCellArray.add(["titleName":"EffectPatterns: ","titleValue":effectPatternCountString,"expandable":"effectPattern","abilityKey":"effectPattern"])
        if (isEffectPatternExpanded){
            for dict in effectPattern{
                abilityCellArray.add(["titleName":(dict as! NSDictionary).object(forKey:"coordinate")!])
            }
            abilityCellArray.add(["titleName":"Add Effect Pattern Postion"])
        }
        abilityCellArray.add(["titleName":"Animation Time: ","titleValue":String(ability.animationTime),"abilityKey":"animationTime"])
        var dtpCountString = "0"
        if(damageAnimations != nil){
            dtpCountString = String(damageAnimations.count)
        }
        else{
            damageAnimations = NSArray()
        }
        abilityCellArray.add(["titleName":"Damage at Time for Percentage: ","titleValue":dtpCountString,"expandable":"damageAnimation","abilityKey":"damageAnimation"])
        if (isDTPExpanded){
            for dict in damageAnimations{
                abilityCellArray.add(["titleName":"Frame","titleValue":(dict as! NSDictionary).object(forKey:"stringValue")!])
            }
            abilityCellArray.add(["titleName":"Add Percent Damage at Time"])
        }
        abilityDetailTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setTextForKey(text: String, key: String){
        if(stringKeys.contains(key)){
            ability.setValue(text, forKey: key)
        }
        else if(intKeys.contains(key)){
            ability.setValue(Int(text), forKey: key)
        }
        else if (floatKeys.contains(key)){
            ability.setValue(Float(text), forKey: key)
        }
        else{
            print("Unknown type found in setTextForKey")
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
