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
    @IBOutlet weak var attribute7Label: UILabel!
    @IBOutlet weak var attribute7TextField: UITextField!
    @IBOutlet weak var attribute8Label: UILabel!
    @IBOutlet weak var attribute8TextField: UITextField!
    
    @IBOutlet weak var attribute3Switch: UISwitch!
    @IBOutlet weak var attribute4Switch: UISwitch!
    @IBOutlet weak var attribute5Switch: UISwitch!
    @IBOutlet weak var attribute6Switch: UISwitch!
    @IBOutlet weak var attribute7Switch: UISwitch!
    @IBOutlet weak var attribute8Switch: UISwitch!
    
    
    
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
        self.attribute7TextField.tag = 7
        self.attribute8TextField.tag = 8
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                if(type == NSAttributeType.integer16AttributeType || type == NSAttributeType.integer32AttributeType){
                    keyBoardType = .numberPad
                }
                else if(type == NSAttributeType.floatAttributeType){
                    keyBoardType = .decimalPad
                }
                else if(type == NSAttributeType.booleanAttributeType){
                    keyBoardType = .twitter //#programmerThings actually used to toggle the UI switch as an input.
                }
                else{
                    keyBoardType = .default
                }
                if(attribute3Label.text == "Label"){
                    attribute3Label.text = title
                    attribute3Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute3Switch.isHidden = false
                        attribute3Switch.tag = i
                    }
                    else{
                        attribute3TextField.isHidden = false
                        attribute3TextField.keyboardType = keyBoardType
                        attribute3TextField.tag = i
                    }
                    continue
                }
                if(attribute4Label.text == "Label"){
                    attribute4Label.text = title
                    attribute4Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute4Switch.isHidden = false
                        attribute4Switch.tag = i
                    }
                    else{
                        attribute4TextField.isHidden = false
                        attribute4TextField.keyboardType = keyBoardType
                        attribute4TextField.tag = i
                    }
                    continue
                }
                if(attribute5Label.text == "Label"){
                    attribute5Label.text = title
                    attribute5Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute5Switch.isHidden = false
                        attribute5Switch.tag = i
                    }
                    else{
                        attribute5TextField.isHidden = false
                        attribute5TextField.keyboardType = keyBoardType
                        attribute5TextField.tag = i
                    }
                    continue
                }
                if(attribute6Label.text == "Label"){
                    attribute6Label.text = title
                    attribute6Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute6Switch.isHidden = false
                        attribute6Switch.tag = i
                    }
                    else{
                        attribute6TextField.isHidden = false
                        attribute6TextField.keyboardType = keyBoardType
                        attribute6TextField.tag = i
                    }
                    continue
                }
                if(attribute7Label.text == "Label"){
                    attribute7Label.text = title
                    attribute7Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute7Switch.isHidden = false
                        attribute7Switch.tag = i
                    }
                    else{
                        attribute7TextField.isHidden = false
                        attribute7TextField.keyboardType = keyBoardType
                        attribute7TextField.tag = i
                    }
                    continue
                }
                if(attribute8Label.text == "Label"){
                    attribute8Label.text = title
                    attribute8Label.isHidden = false
                    if(keyBoardType == .twitter){
                        attribute8Switch.isHidden = false
                        attribute8Switch.tag = i
                    }
                    else{
                        attribute8TextField.isHidden = false
                        attribute8TextField.keyboardType = keyBoardType
                        attribute8TextField.tag = i
                    }
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
    
    func keyboardWillShow(sender: NSNotification) {
        self.abilityEffectDetailPicker.isUserInteractionEnabled = false
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.abilityEffectDetailPicker.isUserInteractionEnabled = true
    }
    
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
                    if (key == attribute3Label.text) {
                        if (!attribute3TextField.isHidden){
                            attribute3TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute3Switch.isHidden){
                            attribute3Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool : false
                        }
                        
                    }
                    else if (key == attribute4Label.text) {
                        if (!attribute4TextField.isHidden){
                            attribute4TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute4Switch.isHidden){
                            attribute4Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool : false
                        }
                        
                    }
                    else if (key == attribute5Label.text) {
                        if (!attribute5TextField.isHidden){
                            attribute5TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute5Switch.isHidden){
                            attribute5Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool! : false
                        }
                        
                    }
                    else if (key == attribute6Label.text) {
                        if (!attribute6TextField.isHidden){
                            attribute6TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute6Switch.isHidden){
                            attribute6Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool : false
                        }
                        
                    }
                    else if (key == attribute7Label.text) {
                        if (!attribute7TextField.isHidden){
                            attribute7TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute7Switch.isHidden){
                            attribute7Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool : false
                        }
                        
                    }
                    else if (key == attribute8Label.text) {
                        if (!attribute8TextField.isHidden){
                            attribute8TextField.text = self.stringFromManagedObjectWithKey(managedObject: setEffect, key: key)
                        }
                        else if (!attribute8Switch.isHidden){
                            attribute8Switch.isOn = setEffect.value(forKey: key) != nil ? setEffect.value(forKey: key) as! Bool : false
                        }
                        
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
            return value as? String ?? ""
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
        if (!attribute7TextField.isHidden) {
            attribute7TextField.text = ""
        }
        if (!attribute8TextField.isHidden) {
            attribute8TextField.text = ""
        }
    }
    
    //MARK: UIButton functions
    
    @IBAction func onSwitch3ValueChange(_ sender: Any) {
        let key = keys[attribute3Switch.tag] as! String
        self.abilityEffect.setValue(attribute3Switch.isOn, forKey:key)
    }
    
    @IBAction func onSwitch4ValueChange(_ sender: Any) {
        let key = keys[attribute4Switch.tag] as! String
        self.abilityEffect.setValue(attribute4Switch.isOn, forKey:key)
    }
    
    @IBAction func onSwitch5ValueChange(_ sender: Any) {
        let key = keys[attribute5Switch.tag] as! String
        self.abilityEffect.setValue(attribute5Switch.isOn, forKey:key)
        print(self.abilityEffect.value(forKey: key) ?? "nil")
    }
    
    @IBAction func onSwitch6ValueChange(_ sender: Any) {
        let key = keys[attribute6Switch.tag] as! String
        self.abilityEffect.setValue(attribute6Switch.isOn, forKey:key)
    }
    
    @IBAction func onSwitch7ValueChange(_ sender: Any) {
        let key = keys[attribute7Switch.tag] as! String
        self.abilityEffect.setValue(attribute7Switch.isOn, forKey:key)
    }
    
    
    @IBAction func onSwitch8ValueChange(_ sender: Any) {
        let key = keys[attribute8Switch.tag] as! String
        self.abilityEffect.setValue(attribute8Switch.isOn, forKey:key)
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
