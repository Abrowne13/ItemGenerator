//
//  AddAbilityViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/10/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class AddAbilityViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    
    var editMode: Bool = false
    var editAbility: Ability!
    var index: Int = -1
    
    var abilityList: [NSManagedObject] = []
    var abilityTypes: [String]!
    
    var name: String = ""
    var abilityID: Int = -1
    var modifierType: String = ""
    var abilityDescription = ""
    var targetType: String = ""
    var apCost: Int = 0
    var levelUnlock: Int = 0
    var baseValue: Int = 0
    var ratioValue: Float = 0
    var range: Int = 0
    var radius: Int = 0
    var aniTime: Float = 0
    var eva: Int = 0
    var rng: Int = 1
    var mov: Int = 0
    
    
    @IBOutlet weak var textFldType: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Ability")
        fetchRequest.returnsObjectsAsFaults = false
        
        //3
        do {
            abilityList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (editMode){
            self.title = "Edit Ability"
            index = abilityList.index(of: editAbility)!
            
            self.setFields()
        }
        else{
            self.title = "Add Ability"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Add Ability"
        
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapBackground.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapBackground)
        
        let pickerType : UIPickerView = UIPickerView()
        pickerType.dataSource = self
        pickerType.delegate = self
        
        abilityTypes = ["atk","intl","hit","def","res","eva","hp","ap"]
        textFldType.inputView = pickerType
    }
    
    func dismissKeyboard(_ sender:Any)
    {
        self.view.endEditing(true)
    }
    
    
    @IBAction func navSaveBtnPushed(_ sender: Any) {
        self.btnSavePushed(self);
    }
    
    @IBAction func btnSavePushed(_ sender: Any) {
        
        self.view.endEditing(true)
        
        //All the fun error handling and ect here...
        var errorMsg : String = "Check the following fields:\n"
        var hasError : Bool = false
        
        if (name == "") {
            errorMsg.append("Name ")
            hasError = true
        }
        
        if (abilityID == -1){
            errorMsg.append("Ability ID ")
            hasError = true
        }
        
        if (modifierType == "") {
            errorMsg.append("modifierType ")
            hasError = true
        }
        
        if (rng <= 0) {
            errorMsg.append("Rng ")
            hasError = true
        }
        
        if (abilityDescription == ""){
            abilityDescription = "Currently Unflavored"
        }
        
        if (hasError){
            let alertError : UIAlertController = UIAlertController(title: "Invalid Ability", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            })
            alertError.addAction(alertAction)
            
            self.present(alertError, animated: false, completion: {
                return
            })
        }
        else{
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            // 1
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: "Ability",
                                           in: managedContext)!
            
            var ability: NSManagedObject
            
            //Not that simple to edit
            if(editMode){
                ability = editAbility;
            }
            else{
                ability = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
            }
            
            ability.setValue(name, forKey: "name")
            ability.setValue(abilityID, forKey: "abilityID")
            ability.setValue(abilityDescription, forKey: "abilityDescription")
            ability.setValue(modifierType, forKey: "modifierType")
            ability.setValue(targetType, forKey: "targetType")
            ability.setValue(apCost, forKey: "apCost")
            ability.setValue(levelUnlock, forKey: "levelUnlock")
            ability.setValue(baseValue, forKey: "baseValue")
            ability.setValue(ratioValue, forKey: "ratioValue")
            ability.setValue(range, forKey: "range")
            ability.setValue(radius, forKey: "radius")
            ability.setValue(aniTime, forKey: "animationTime")
            
            // 4
            do {
                //Edit mode needs to be checked here
                try managedContext.save()
                if !editMode {
                    abilityList.append(ability)
                }
                let navController = self.navigationController!
                navController.popViewController(animated: true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return abilityTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return abilityTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textFldType.text = abilityTypes[row]
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Textfield: ", textField.tag)
        
        //Textfield tags 5-15 are the stats
        
        switch textField.tag {
        case 1:
            name = textField.text!
            break
        case 2:
            guard let tempStr: String = textField.text, textField.text != "" else{
                abilityID = -1
                break
            }
            abilityID = Int(tempStr)!
            break
        case 3:
            modifierType = textField.text!
            break
        case 4:
            abilityDescription = textField.text!
            break
        case 5:
            targetType = textField.text!
            break
        case 6:
            guard let tempStr: String = textField.text, textField.text != "" else{
                apCost = 0
                break
            }
            apCost = Int(tempStr)!
            break
        case 7:
            guard let tempStr: String = textField.text, textField.text != "" else{
                levelUnlock = 0
                break
            }
            levelUnlock = Int(tempStr)!
            break
        case 8:
            guard let tempStr: String = textField.text, textField.text != "" else{
                baseValue = 0
                break
            }
            baseValue = Int(tempStr)!
            break
        case 9:
            guard let tempStr: String = textField.text, textField.text != "" else{
                ratioValue = 0
                break
            }
            ratioValue = Float(tempStr)!
            break
        case 10:
            guard let tempStr: String = textField.text, textField.text != "" else{
                range = 0
                break
            }
            range = Int(tempStr)!
            break
        case 11:
            guard let tempStr: String = textField.text, textField.text != "" else{
                radius = 0
                break
            }
            radius = Int(tempStr)!
            break
        case 12:
            guard let tempStr: String = textField.text, textField.text != "" else{
                aniTime = 0
                break
            }
            aniTime = Float(tempStr)!
            break
        case 13:
            guard let tempStr: String = textField.text, textField.text != "" else{
                eva = 0
                break
            }
            eva = Int(tempStr)!
            break
        case 14:
            guard let tempStr: String = textField.text, textField.text != "" else{
                rng = 1
                break
            }
            mov = Int(tempStr)!
            break
        case 15:
            guard let tempStr: String = textField.text, textField.text != "" else{
                mov = 0
                break
            }
            mov = Int(tempStr)!
            break
            
        default:
            print("Umm textfield with tag: ",textField.tag)
            break
        }
        
        //Should require a name, itemNo and type.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Set the fields from editItem
    func setFields(){
        for i in 1 ..< 16{
            switch i {
            case 1:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                name = editAbility.name!
                textField.text = editAbility.name
                
                break
                
            case 2:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                abilityID = Int(editAbility.abilityID)
                textField.text = String(editAbility.abilityID)
                
                break
                
            case 3:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                modifierType = editAbility.modifierType!
                textField.text = editAbility.modifierType
                
                break
                
            case 4:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                abilityDescription = editAbility.abilityDescription!
                textField.text = editAbility.abilityDescription
                
                break
               
            case 5:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                targetType = editAbility.targetType!
                textField.text = editAbility.targetType
                
                break
                
            case 6:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                apCost = Int(editAbility.apCost)
                textField.text = String(editAbility.apCost)
                
                break
                
            case 7:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                levelUnlock = Int(editAbility.levelUnlock)
                textField.text = String(editAbility.levelUnlock)
                
                break
                
            case 8:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                baseValue = Int(editAbility.baseValue)
                textField.text = String(editAbility.baseValue)
                
                break
                
            case 9:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                ratioValue = Float(editAbility.ratioValue)
                textField.text = String(editAbility.ratioValue)
                
                break
               
            case 10:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                range = Int(editAbility.range)
                textField.text = String(editAbility.range)
                
                break
                
            case 11:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                radius = Int(editAbility.radius)
                textField.text = String(editAbility.radius)
                
                break
                
            case 12:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                aniTime = Float(editAbility.animationTime)
                textField.text = String(editAbility.animationTime)
                
                break
                /*
            case 13:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                eva = Int(editItem.eva)
                textField.text = String(editItem.eva)
                
                break
                
            case 14:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                rng = Int(editItem.rng)
                textField.text = String(editItem.rng)
                
                break
                
            case 15:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                mov = Int(editItem.mov)
                textField.text = String(editItem.mov)
                
                break
              */  
            default:
                
                break
            }
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
