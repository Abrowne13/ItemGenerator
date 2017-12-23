//
//  AbilityDetailTableViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/23/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var ability: Ability!
    var abilityCellArray: NSMutableArray!
    var targetEffects: NSArray!
    var casterEffects: NSArray!
    var effectPattern: NSArray!
    var damageAnimations: NSArray!
    var isTargetEffectExpanded = false
    var isCasterEffectExpanded = false
    var isEffectPatternExpanded = false
    var isDTPExpanded = false;
    var pickerViewData: NSMutableArray = []
    var effectPickerView = UIPickerView()
    var activeTextField: UITextField!
    let stringKeys = ["name","modifierType","abilityDescription","targetType"]
    let intKeys = ["abilityID","levelUnlock","apCost","baseEffect","range","radius"]
    let floatKeys = ["ratioEffect","animationTime"]
    let twoTextFieldKeys = ["damageAtTimeForPercentage","effectPattern"]
    @IBOutlet weak var abilityDetailTableView: UITableView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Edit Ability"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.loadPickerViewData()
        effectPickerView.dataSource = self
        effectPickerView.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        targetEffects = ability.targetEffects as? NSArray
        casterEffects = ability.casterEffects as? NSArray
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
        let cellDict = abilityCellArray.object(at: indexPath.row) as? NSDictionary
        let abilityKey = cellDict?.object(forKey: "abilityKey") as! String?
        let subArray = cellDict?.object(forKey:"subArray") as! String?
        let checkString = abilityKey ?? subArray!
        if (twoTextFieldKeys.contains(checkString)) {
            let tableCell : AbilityDetailTwoEntryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityDetailTwoEntryCell") as! AbilityDetailTwoEntryTableViewCell
            tableCell.abilityDetailLeftTextField.tag = indexPath.row
            tableCell.abilityDetailRightTextField.tag = indexPath.row
            let str1 = cellDict?.object(forKey: "titleName") as? String ?? ""
            let str2 = cellDict?.object(forKey: "titleValue") as? String ?? ""
            tableCell.abilityDetailLabel?.text = str1 + str2
            let type = cellDict?.object(forKey: "type") as? String ?? ""
            if(subArray != nil && type != "default"){
                tableCell.accessoryType = .disclosureIndicator
            }
            else{
                tableCell.accessoryType = .none
            }
            return tableCell
        }
        else{
            let tableCell : AbilityDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "abilityDetailCell") as! AbilityDetailTableViewCell
            tableCell.abilityDetailTextField.delegate = self
            tableCell.abilityDetailTextField.tag = indexPath.row
            if(abilityKey != nil){
                if(intKeys.contains(abilityKey!)){
                    tableCell.abilityDetailTextField.keyboardType = .numberPad
                }
                else if(floatKeys.contains(abilityKey!)){
                    tableCell.abilityDetailTextField.keyboardType = .decimalPad
                }
            }
            else{
                if (subArray == "targetEffect" || subArray == "casterEffect") {
                    tableCell.abilityDetailTextField.inputView = effectPickerView
                    let type = cellDict?.object(forKey: "type") as? String ?? ""
                    if(type != "default"){
                        tableCell.accessoryType = .disclosureIndicator
                    }
                    else{
                        tableCell.accessoryType = .none
                    }
                }
            }
            let str1 = cellDict?.object(forKey: "titleName") as? String ?? ""
            let str2 = cellDict?.object(forKey: "titleValue") as? String ?? ""
            tableCell.abilityDetailLabel?.text = str1 + str2
            return tableCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellDict = abilityCellArray[indexPath.row]
        let expandbleString = (cellDict as! NSDictionary).object(forKey:"expandable") as! String?
        if (expandbleString == "targetEffect") {
            isTargetEffectExpanded = !isTargetEffectExpanded
            self.collapseSubArrayCellsForSubarray(subArray: "targetEffect")
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "casterEffect") {
            isCasterEffectExpanded = !isCasterEffectExpanded
            self.collapseSubArrayCellsForSubarray(subArray: "casterEffect")
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "effectPattern") {
            isEffectPatternExpanded = !isEffectPatternExpanded
            self.collapseSubArrayCellsForSubarray(subArray: "effectPattern")
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else if (expandbleString == "damageAtTimeForPercentage") {
            isDTPExpanded = !isDTPExpanded
            self.collapseSubArrayCellsForSubarray(subArray: "damageAtTimeForPercentage")
            self.updateAbilityCellArray()
            tableView.reloadData()
        }
        else{
            let subArray = (cellDict as! NSDictionary).object(forKey:"subArray") as! String? ?? ""
            if(twoTextFieldKeys.contains(subArray)){
                let cell = tableView.cellForRow(at: indexPath) as! AbilityDetailTwoEntryTableViewCell
                if (cell.abilityDetailLeftTextField.isHidden) {
                    if(subArray == "effectPattern"){
                        cell.abilityDetailLeftTextField.placeholder = "x"
                        cell.abilityDetailRightTextField.placeholder = "y"
                    }
                    else if (subArray == "damageAtTimeForPercentage"){
                        cell.abilityDetailLeftTextField.placeholder = "damageAtTime"
                        cell.abilityDetailRightTextField.placeholder = "forPercentage"
                    }
                    cell.abilityDetailLabel.isHidden = true
                    cell.abilityDetailLeftTextField.isHidden = false
                    cell.abilityDetailRightTextField.isHidden = false
                    cell.abilityDetailLeftTextField.becomeFirstResponder()
                }
                else{
                    let cellTwoEntry = tableView.cellForRow(at: indexPath) as! AbilityDetailTwoEntryTableViewCell
                    if (subArray == "effectPattern"){
                        let pattern = NSMutableDictionary()
                        pattern.setValue(["x":Int(cellTwoEntry.abilityDetailLeftTextField.text!),"y":Int(cellTwoEntry.abilityDetailRightTextField.text!)], forKey: "coordinate")
                        effectPattern = effectPattern.adding(pattern) as NSArray!
                        ability.effectPattern = effectPattern
                        let context = ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        self.updateAbilityCellArray()
                    }
                    else if (subArray == "damageAtTimeForPercentage"){
                        let pattern = NSMutableDictionary()
                        pattern.setValue(["damageAtTime":Float(cellTwoEntry.abilityDetailLeftTextField.text!),"forPercentage":Float(cellTwoEntry.abilityDetailRightTextField.text!)], forKey: "damageAtTimeForPercentage")
                        damageAnimations = damageAnimations.adding(pattern) as NSArray!
                        ability.damageAtTimeForPercentage = damageAnimations
                        let context = ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        self.updateAbilityCellArray()
                    }
                    cell.abilityDetailLabel.isHidden = false
                    cell.abilityDetailLeftTextField.isHidden = true
                    cell.abilityDetailRightTextField.isHidden = true
                    cell.abilityDetailLeftTextField.resignFirstResponder()
                    cell.abilityDetailRightTextField.resignFirstResponder()
                }
            }
            else{
                let cell = tableView.cellForRow(at: indexPath) as! AbilityDetailTableViewCell
                if (cell.abilityDetailTextField.isHidden){
                    cell.abilityDetailLabel.isHidden = true
                    cell.abilityDetailTextField.placeholder = cell.abilityDetailLabel.text
                    cell.abilityDetailTextField.isHidden = false
                    cell.abilityDetailTextField.becomeFirstResponder()
                }
                else{
                    cell.abilityDetailLabel.isHidden = false
                    cell.abilityDetailTextField.isHidden = true
                    if (cell.abilityDetailTextField.text == "") {
                        cell.abilityDetailLabel.text = cell.abilityDetailTextField.placeholder
                    }
                    else{
                        let dict = self.abilityCellArray.object(at: indexPath.row) as! NSDictionary
                        if(dict.object(forKey: "abilityKey") as? String != nil){
                            self.setTextForKey(text: cell.abilityDetailTextField.text!, key: dict.object(forKey: "abilityKey") as! String)
                            self.updateAbilityCellArray()
                            self.abilityDetailTableView.reloadData()
                            cell.abilityDetailTextField.text = ""
                        }
                        else{
                            let subArray = (cellDict as! NSDictionary).object(forKey:"subArray") as! String?
                            
                            if (subArray == "targetEffect") {
                                targetEffects = targetEffects.adding(cell.abilityDetailTextField.text!) as NSArray!
                                ability.targetEffects = targetEffects
                                let context = ability.managedObjectContext;
                                do {
                                    try context?.save()
                                }
                                catch let error as NSError {
                                    print("Could not save. \(error), \(error.userInfo)")
                                }
                                self.updateAbilityCellArray()
                                
                            }
                            else if (subArray == "casterEffect") {
                                casterEffects = casterEffects.adding(cell.abilityDetailTextField.text!) as NSArray!
                                ability.casterEffects = casterEffects
                                let context = ability.managedObjectContext;
                                do {
                                    try context?.save()
                                }
                                catch let error as NSError {
                                    print("Could not save. \(error), \(error.userInfo)")
                                }
                                self.updateAbilityCellArray()
                                
                            }
                            else{
                                
                            }
                        }
                    }
                }
                cell.abilityDetailTextField.resignFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dict = abilityCellArray.object(at: indexPath.row) as! NSDictionary
        let subArray = dict.object(forKey: "subArray") as? String
        let type = dict.object(forKey: "type") as? String
        if (subArray != nil && type == nil) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let cellDict = self.abilityCellArray.object(at: indexPath.row) as! NSDictionary
            let subArray = cellDict.object(forKey: "subArray") as! String
            if (subArray == "targetEffect"){
                for abilityEffectString in self.targetEffects{
                    if (abilityEffectString as! String == cellDict.object(forKey: "titleName") as! String){
                        let effectsArray = NSMutableArray.init(array: self.targetEffects)
                        effectsArray.remove(abilityEffectString)
                        self.targetEffects = effectsArray
                        self.ability.targetEffects = self.targetEffects
                        let context = self.ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            else if (subArray == "casterEffect"){
                for abilityEffectString in self.casterEffects{
                    if (abilityEffectString as! String == cellDict.object(forKey: "titleName") as! String){
                        let effectsArray = NSMutableArray.init(array: self.casterEffects)
                        effectsArray.remove(abilityEffectString)
                        self.casterEffects = effectsArray
                        self.ability.casterEffects = self.casterEffects
                        let context = self.ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            else if (subArray == "effectPattern"){
                for coordinate in self.effectPattern{
                    let coordDict = (coordinate as! NSMutableDictionary).object(forKey: "coordinate")
                    let x = ((coordDict as? NSDictionary)?.object(forKey:"x") as? Int) ?? 0
                    let y = ((coordDict as? NSDictionary)?.object(forKey:"y") as? Int) ?? 0
                    let coordString = "\(String(x)),\(y)"
                    if (coordString == cellDict.object(forKey: "titleName") as! String){
                        let coordinateArray = NSMutableArray.init(array: self.effectPattern)
                        coordinateArray.remove(coordinate)
                        self.effectPattern = coordinateArray
                        self.ability.effectPattern = self.effectPattern
                        let context = self.ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            //Need to pull damageAtTimeForPercentage from self.damageAnimations format it and compare it to titleName
            else if (subArray == "damageAtTimeForPercentage"){
                for datfp in self.damageAnimations{
                    let datfpDict = (datfp as! NSDictionary).object(forKey:"damageAtTimeForPercentage") as! NSDictionary!
                    let time = (datfpDict?.object(forKey:"damageAtTime") as? Float) ?? 0
                    let percentage = (datfpDict?.object(forKey:"forPercentage") as? Float) ?? 0
                    let datfpString = "\(String(time)),\(String(percentage))"
                    if (datfpString == cellDict.object(forKey:
                        "titleName") as! String){
                        let damageAniArray = NSMutableArray.init(array: self.damageAnimations)
                        damageAniArray.remove(datfp)
                        self.damageAnimations = damageAniArray
                        self.ability.damageAtTimeForPercentage = self.damageAnimations
                        let context = self.ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
            self.updateAbilityCellArray()
        }
        deleteAction.backgroundColor = UIColor.red
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
        var targetEffectCountString = "0"
        if(targetEffects != nil){
            targetEffectCountString = String(targetEffects.count)
        }
        else{
            targetEffects = NSArray()
        }
        abilityCellArray.add(["titleName":"Target Effects: ","titleValue":targetEffectCountString,"expandable":"targetEffect","abilityKey":"targetEffects"])
        if (isTargetEffectExpanded){
            for string in targetEffects{
                abilityCellArray.add(["titleName":string as! String,"subArray":"targetEffect"])
            }
            abilityCellArray.add(["titleName":"Add Target Effect","subArray":"targetEffect","type":"default"])
        }
        var casterEffectCountString = "0"
        if(casterEffects != nil){
            casterEffectCountString = String(casterEffects.count)
        }
        else{
            casterEffects = NSArray()
        }
        abilityCellArray.add(["titleName":"Caster Effects: ","titleValue":casterEffectCountString,"expandable":"casterEffect","abilityKey":"casterEffects"])
        if (isCasterEffectExpanded){
            for string in casterEffects{
                abilityCellArray.add(["titleName":string as! String,"subArray":"casterEffect"])
            }
            abilityCellArray.add(["titleName":"Add Caster Effect","subArray":"casterEffect","type":"default"])
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
                let coordinate = (dict as! NSDictionary).object(forKey:"coordinate") as! NSDictionary!
                let x = (coordinate?.object(forKey:"x") as? Int) ?? 0
                let y = (coordinate?.object(forKey:"y") as? Int) ?? 0
                abilityCellArray.add(["titleName":"\(String(x)),\(y)","subArray":"effectPattern"])
            }
            abilityCellArray.add(["titleName":"Add Effect Pattern Postion","subArray":"effectPattern","type":"default"])
        }
        abilityCellArray.add(["titleName":"Animation Time: ","titleValue":String(ability.animationTime),"abilityKey":"animationTime"])
        var dtpCountString = "0"
        if(damageAnimations != nil){
            dtpCountString = String(damageAnimations.count)
        }
        else{
            damageAnimations = NSArray()
        }
        abilityCellArray.add(["titleName":"Damage at Time for Percentage: ","titleValue":dtpCountString,"expandable":"damageAtTimeForPercentage","abilityKey":"damageAtTimeForPercentage"])
        if (isDTPExpanded){
            for dict in damageAnimations{
                let datfp = (dict as! NSDictionary).object(forKey:"damageAtTimeForPercentage") as! NSDictionary!
                let time = (datfp?.object(forKey:"damageAtTime") as? Float) ?? 0
                let percentage = (datfp?.object(forKey:"forPercentage") as? Float) ?? 0
                abilityCellArray.add(["titleName":"\(String(time)),\(String(percentage))","subArray":"damageAtTimeForPercentage"])
            }
            abilityCellArray.add(["titleName":"Add Percent Damage at Time","subArray":"damageAtTimeForPercentage","type":"default"])
        }
        abilityDetailTableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        abilityDetailTableView.scrollToRow(at: [0,textField.tag], at: UITableViewScrollPosition.top, animated: true)
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cellDict = self.abilityCellArray.object(at: textField.tag) as! NSDictionary
        let abilityKey = cellDict.object(forKey: "abilityKey") as! String?
        let subArray = cellDict.object(forKey:"subArray") as! String?
        let checkString = abilityKey ?? subArray!
        if (twoTextFieldKeys.contains(checkString)) {
            let cell = abilityDetailTableView.cellForRow(at: [0,textField.tag]) as! AbilityDetailTwoEntryTableViewCell
            if (textField.text != ""){
                if (cell.abilityDetailLeftTextField.text != "" && cell.abilityDetailLeftTextField.text != "") {
                    if (subArray == "effectPattern"){
                        let effectPatterns = ability.effectPattern as! NSMutableArray
                        let pattern = NSMutableDictionary()
                    pattern.setValue(["x":Int(cell.abilityDetailLeftTextField.text!),"y":Int(cell.abilityDetailRightTextField.text!)], forKey: "coordinate")
                        effectPatterns.add(pattern)
                        ability.effectPattern = effectPatterns
                        let context = ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                    else if (subArray == "damageAtTimeForPercentage"){
                        let animationArray = ability.damageAtTimeForPercentage as! NSMutableArray
                        let pattern = NSMutableDictionary()
                        pattern.setValue(["damageAtTime":Float(cell.abilityDetailLeftTextField.text!),"forPercentage":Float(cell.abilityDetailRightTextField.text!)], forKey: "damageAtTimeForPercentage")
                        animationArray.add(pattern)
                        ability.damageAtTimeForPercentage = animationArray
                        let context = ability.managedObjectContext;
                        do {
                            try context?.save()
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
                
            }
            cell.abilityDetailLabel.isHidden = false
            cell.abilityDetailLeftTextField.isHidden = true
            cell.abilityDetailRightTextField.isHidden = true
            textField.resignFirstResponder()
            return true
        }
        else{
            let cell = abilityDetailTableView.cellForRow(at: [0,textField.tag]) as! AbilityDetailTableViewCell
            cell.abilityDetailLabel.isHidden = false
            cell.abilityDetailTextField.isHidden = true
            if (cell.abilityDetailTextField.text == "") {
                cell.abilityDetailLabel.text = cell.abilityDetailTextField.placeholder
            }
            else{
                self.setTextForKey(text: cell.abilityDetailTextField.text!, key: cellDict.object(forKey: "abilityKey") as! String)
                self.updateAbilityCellArray()
                self.abilityDetailTableView.reloadData()
                cell.abilityDetailTextField.text = ""
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 250, right: 0)
        abilityDetailTableView.contentInset = contentInset
        abilityDetailTableView.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        abilityDetailTableView.contentInset = contentInset
        abilityDetailTableView.scrollIndicatorInsets = contentInset
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
            return
        }
        let context = ability.managedObjectContext;
        do {
            try context?.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Still does not solve all the UI bugs, just makes them fixable.
    func collapseSubArrayCellsForSubarray(subArray: String){
        for i in 0..<abilityCellArray.count{
            let dict = abilityCellArray[i] as! NSDictionary
            let subArrayValue = dict.object(forKey:"subArray") as? String
            if(subArrayValue != nil && subArrayValue == subArray){
                let cell = abilityDetailTableView.cellForRow(at: [0,i]) as? AbilityDetailTableViewCell
                if (cell != nil){
                    cell?.abilityDetailTextField.isHidden = true
                    cell?.abilityDetailLabel.isHidden = false
                }
            }
        }
    }
    
    // MARK: UIPickerView Delegate Functions and Helper Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTextField.text = pickerViewData[row] as? String
    }
    
    
    func loadPickerViewData(){
        pickerViewData.removeAllObjects()
        let nameDicts = CoreDataManager.sharedInstance.getAllAbilityEffectNames()
        for name in nameDicts{
            pickerViewData.add((name as! NSDictionary).value(forKey: "name") ?? "empty")
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
