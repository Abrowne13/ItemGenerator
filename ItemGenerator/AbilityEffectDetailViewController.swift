//
//  AbilityEffectDetailViewController.swift
//  ItemGenerator
//
//  Created by Admin on 10/31/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class AbilityEffectDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var abilityEffectDetailPicker: UIPickerView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var procLabel: UILabel!
    @IBOutlet weak var procTextField: UITextField!
    @IBOutlet weak var attribute3Label: UILabel!
    @IBOutlet weak var attribute3TextField: UITextField!
    @IBOutlet weak var attribute4Label: UILabel!
    @IBOutlet weak var attribute4TextField: UITextField!
    @IBOutlet weak var attribute5Label: UILabel!
    @IBOutlet weak var attribute5TextField: UITextField!
    @IBOutlet weak var attribute6Label: UILabel!
    @IBOutlet weak var attribute6TextField: UITextField!
    
    //If you ever want to play with the bottom contraint for the contentView
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    
    var abilityEffectName: String!
    var abilityEffect: NSManagedObject!
    var abilityEffects: [NSManagedObject] = []
    var keys: NSMutableArray = []
    var pickerRows: NSMutableArray! = []
    var managedContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    var entity: NSEntityDescription = NSEntityDescription()

    //MARK: Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.abilityEffectDetailPicker.delegate = self
        self.nameTextField.tag = 1
        self.procTextField.tag = 2
        self.attribute3TextField.tag = 3
        self.attribute4TextField.tag = 4
        self.attribute5TextField.tag = 5
        self.attribute6TextField.tag = 6
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = abilityEffectName
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: abilityEffectName,
                                                in: managedContext)!
        let attributes = entity.attributesByName
        let values:NSMutableArray = []
        for attribute in attributes{
            if(attribute.key == "effectType"){
                continue
            }
            keys.add(attribute.key)
            values.add(attribute.value.attributeType)
        }
        
        for i in 0..<keys.count{
            let title = keys[i] as! String
            if(title == "name"){
                nameTextField.tag = i
                continue
            }
            else if(title == "procRate"){
                procLabel.text = "procRate"
                procTextField.keyboardType = .decimalPad
                procTextField.tag = i
            }
            else{
                let type = values[i] as! NSAttributeType
                let keyBoardType:UIKeyboardType
                if(type == NSAttributeType.integer16AttributeType){
                    keyBoardType = .numberPad
                }
                else if(type == NSAttributeType.floatAttributeType){
                    keyBoardType = .decimalPad
                }
                else{
                    keyBoardType = .default
                }
                
                if(attribute3Label.text == "Label"){
                    attribute3Label.text = title
                    attribute3Label.isHidden = false
                    attribute3TextField.isHidden = false
                    attribute3TextField.keyboardType = keyBoardType
                    attribute3TextField.tag = i
                    continue
                }
                if(attribute4Label.text == "Label"){
                    attribute4Label.text = title
                    attribute4Label.isHidden = false
                    attribute4TextField.isHidden = false
                    attribute4TextField.keyboardType = keyBoardType
                    attribute4TextField.tag = i
                    continue
                }
                if(attribute5Label.text == "Label"){
                    attribute5Label.text = title
                    attribute5Label.isHidden = false
                    attribute5TextField.isHidden = false
                    attribute5TextField.keyboardType = keyBoardType
                    attribute5TextField.tag = i
                    continue
                }
                if(attribute6Label.text == "Label"){
                    attribute6Label.text = title
                    attribute6Label.isHidden = false
                    attribute6TextField.isHidden = false
                    attribute6TextField.keyboardType = keyBoardType
                    attribute6TextField.tag = i
                    continue
                }
            }
        }
        self.loadPickerViewData()
        self.setSelectedRow(row: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        managedContext.reset()
    }
    
    //MARK: PickerView Functions
    
    func loadPickerViewData(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: abilityEffectName)
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
        let sortDescripts = [sortDescript]
        fetchRequest.sortDescriptors = sortDescripts
        do {
            abilityEffects = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        pickerRows.removeAllObjects()
        for entries in abilityEffects{
            self.pickerRows?.add(entries.value(forKey: "name") ?? "")
        }
        self.pickerRows.add("Add Entry")
        abilityEffectDetailPicker.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRows.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRows.object(at: row) as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setSelectedRow(row: row)
    }
    
    func setSelectedRow(row:Int) {
        if(row < abilityEffects.count){
            abilityEffect = abilityEffects[row]
        }
        else{
            abilityEffect = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
        }
        self.setTextFieldsFromAbilityEffect(setEffect: abilityEffect)
    }
    
    
    //MARK: TextField Functions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let key = keys[textField.tag] as! String
        
        if(key == "name"){
            self.abilityEffect.setValue(textField.text, forKey: "name")
        }
        else if(key == "procRate"){
            self.abilityEffect.setValue(Float(textField.text!), forKey: "procRate")
        }
        else {
            self.abilityEffect.setValue(self.valueFromTextField(textField: textField), forKey: key)
        }
    }
    
    func valueFromTextField(textField: UITextField)->Any{
        if(textField.keyboardType == .numberPad) {
            return Int(textField.text!) ?? 0
        }
        else if(textField.keyboardType == .decimalPad){
            return Float(textField.text!) ?? 0
        }
        else{
            return textField.text ?? ""
        }
    }
    
    func setTextFieldsFromAbilityEffect(setEffect:NSManagedObject){
        self.clearTextFields()
        if (setEffect.value(forKey: "name") == nil) {
            return
        }
        else{
            for i in 0..<keys.count{
                let key = keys[i] as! String
                if (key == "name") {
                    nameTextField.text = setEffect.value(forKey: key) as! String!
                }
                else if (key == "procRate"){
                    let proc = setEffect.value(forKey: key) as! Float!
                    procTextField.text = proc?.description
                }
                else{
                    if (key == attribute3Label.text && !attribute3TextField.isHidden) {
                        attribute3TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                    }
                    else if (key == attribute4Label.text && !attribute4TextField.isHidden) {
                        attribute4TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                    }
                    else if (key == attribute5Label.text && !attribute5TextField.isHidden) {
                        attribute5TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                    }
                    else if (key == attribute6Label.text && !attribute6TextField.isHidden) {
                        attribute6TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                    }
                }
            }
        }
    }
    
    func stringFromManagedObjectWithKey(managedObject: NSManagedObject, key:String) -> String{
        let value = managedObject.value(forKey: key)
        if((value as? Float) != nil){
            if((value as! Float).truncatingRemainder(dividingBy: 1) == 0){
                return ((value as! Int).description)
                }
            else{
                return ((value as! Float).description)
            }
        }
        else{
            return value as! String
        }
    }
    
    func clearTextFields(){
        nameTextField.text = ""
        procTextField.text = ""
        if (!attribute3TextField.isHidden) {
            attribute3TextField.text = ""
        }
        if (!attribute4TextField.isHidden) {
            attribute4TextField.text = ""
        }
        if (!attribute5TextField.isHidden) {
            attribute5TextField.text = ""
        }
        if (!attribute6TextField.isHidden) {
            attribute6TextField.text = ""
        }
    }
    
    //MARK: Save function and ect.
    
    @IBAction func onSaveAction(_ sender: Any) {
        self.view.endEditing(true)
        let name = abilityEffect.value(forKey: "name") as! String?
        let procRate = abilityEffect.value(forKey: "procRate") as! Float?
        if (name != nil && procRate != nil) {
            if(abilityEffect.value(forKey: "effectType")==nil){
                abilityEffect.setValue(abilityEffectName, forKey: "effectType")
            }
            let context = abilityEffect.managedObjectContext;
            do {
                try context?.save()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self.loadPickerViewData()
        }
        else{
            let alert = UIAlertController(title: "Missing proc or name", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            self.present(alert,animated:false,completion:nil)
        }
    }
    
    @IBAction func onDeleteAction(_ sender: Any) {
        if (abilityEffectDetailPicker.selectedRow(inComponent: 0) < (pickerRows.count - 1)) {
            managedContext.delete(abilityEffect)
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            loadPickerViewData()
        }
        else{
            let alert = UIAlertController(title: "Cannot delete nonexistant ability effect", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            })
            alert.addAction(okAction)
            self.present(alert,animated:false,completion:nil)
        }
    }
    
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
