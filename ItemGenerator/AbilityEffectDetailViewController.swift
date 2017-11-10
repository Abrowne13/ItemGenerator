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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = abilityEffectName
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: abilityEffectName,
                                                in: managedContext)!
        let attributes = entity.attributesByName
        let values:NSMutableArray = []
        for attribute in attributes{
            keys.add(attribute.key)
            values.add(attribute.value.attributeType)
            print(attribute.value.attributeType)
        }
        
        for i in 0..<keys.count{
            let title = keys[i] as! String
            if(title == "name"){
                continue
            }
            else if(title == "procRate"){
                procLabel.text = "procRate"
                procTextField.keyboardType = .decimalPad
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
                    continue
                }
                if(attribute4Label.text == "Label"){
                    attribute4Label.text = title
                    attribute4Label.isHidden = false
                    attribute4TextField.isHidden = false
                    attribute4TextField.keyboardType = keyBoardType
                    continue
                }
                if(attribute5Label.text == "Label"){
                    attribute5Label.text = title
                    attribute5Label.isHidden = false
                    attribute5TextField.isHidden = false
                    attribute5TextField.keyboardType = keyBoardType
                    continue
                }
                if(attribute6Label.text == "Label"){
                    attribute6Label.text = title
                    attribute6Label.isHidden = false
                    attribute6TextField.isHidden = false
                    attribute6TextField.keyboardType = keyBoardType
                    continue
                }
            }
        }
        self.loadPickerViewData()
        
        self.abilityEffect = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
    }
    
    func loadPickerViewData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: abilityEffectName)
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
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            self.abilityEffect.setValue(textField.text, forKey: "name")
        case 2:
            self.abilityEffect.setValue(Float(textField.text!), forKey: "procRate")
        case 3:
            self.abilityEffect.setValue(self.valueFromTextField(textField: textField), forKey: keys[2] as! String)
        case 4:
            self.abilityEffect.setValue(self.valueFromTextField(textField: textField), forKey: keys[3] as! String)
        case 5:
            self.abilityEffect.setValue(self.valueFromTextField(textField: textField), forKey: keys[4] as! String)
        case 6:
            self.abilityEffect.setValue(self.valueFromTextField(textField: textField), forKey: keys[5] as! String)
        default:
            break
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
    
    @IBAction func onSaveAction(_ sender: Any) {
        let name = abilityEffect.value(forKey: "name") as! String?
        let procRate = abilityEffect.value(forKey: "procRate") as! Float?
        if (name != nil && procRate != nil) {
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
            print ("Missing proc or name")
        }
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
