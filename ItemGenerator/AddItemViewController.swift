//
//  AddItemViewController.swift
//  ItemGenerator
//
//  Created by Admin on 4/5/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var editMode: Bool = false
    var editItem: Item!
    var index: Int = -1
    
    var itemList: [NSManagedObject] = []
    var itemTypes: [String]!
    
    var name: String = ""
    var itemNo: Int = -1
    var type: String = ""
    var flavorText = ""
    var hp: Int = 0
    var ap: Int = 0
    var apr: Int = 0
    var atk: Int = 0
    var intl: Int = 0
    var hit: Int = 0
    var def: Int = 0
    var res: Int = 0
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
            NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        //3
        do {
            itemList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (editMode){
            self.title = "Edit Item"
            index = itemList.index(of: editItem)!
            
            self.setFields()
        }
        else{
            self.title = "Add Item"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Add Item"
        
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        tapBackground.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapBackground)
        
        let pickerType : UIPickerView = UIPickerView()
        pickerType.dataSource = self
        pickerType.delegate = self
        
        itemTypes = ["Accessory","Consumable","Fist","Knife","Lance","Shield","Staff","Sword","Tome","Wand"]
        textFldType.inputView = pickerType
    }
    
    func dismissKeyboard(_ sender:Any)
    {
        self.view.endEditing(true)
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
        
        if (itemNo == -1){
            errorMsg.append("ItemNo ")
            hasError = true
        }
        
        if (type == "") {
            errorMsg.append("Type ")
            hasError = true
        }
        
        if (rng <= 0) {
            errorMsg.append("Rng ")
            hasError = true
        }
        
        if (flavorText == ""){
            flavorText = "Currently Unflavored"
        }
        
        if (hasError){
            let alertError : UIAlertController = UIAlertController(title: "Invalid Item", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
            
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
                NSEntityDescription.entity(forEntityName: "Item",
                                           in: managedContext)!
            
            var item: NSManagedObject
            
            
            //Not that simple to edit
            if(editMode){
                item = editItem;
            }
            else{
                item = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
            }
            
            //Hi, you have set the values of item
            item.setValue(name, forKey: "itemName")
            item.setValue(itemNo, forKey: "itemNo")
            item.setValue(flavorText, forKey: "flavorText")
            item.setValue(type, forKey: "type")
            item.setValue(hp, forKey: "hp")
            item.setValue(ap, forKey: "ap")
            item.setValue(apr, forKey: "apr")
            item.setValue(atk, forKey: "atk")
            item.setValue(intl, forKey: "intl")
            item.setValue(hit, forKey: "hit")
            item.setValue(def, forKey: "def")
            item.setValue(res, forKey: "res")
            item.setValue(eva, forKey: "eva")
            item.setValue(mov, forKey: "mov")
            item.setValue(rng, forKey: "rng")
            
            
            // 4
            do {
                //Edit mode needs to be checked here
                try managedContext.save()
                if !editMode {
                    itemList.append(item)
                }
                let navController = self.navigationController!
                navController.popViewController(animated: true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textFldType.text = itemTypes[row]
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
                itemNo = -1
                break
            }
            itemNo = Int(tempStr)!
            break
        case 3:
            type = textField.text!
            break
        case 4:
            flavorText = textField.text!
            break
        case 5:
            guard let tempStr: String = textField.text, textField.text != "" else{
                hp = 0
                break
            }
            hp = Int(tempStr)!
            break
        case 6:
            guard let tempStr: String = textField.text, textField.text != "" else{
                ap = 0
                break
            }
            ap = Int(tempStr)!
            break
        case 7:
            guard let tempStr: String = textField.text, textField.text != "" else{
                apr = 0
                break
            }
            apr = Int(tempStr)!
            break
        case 8:
            guard let tempStr: String = textField.text, textField.text != "" else{
                atk = 0
                break
            }
            atk = Int(tempStr)!
            break
        case 9:
            guard let tempStr: String = textField.text, textField.text != "" else{
                intl = 0
                break
            }
            intl = Int(tempStr)!
            break
        case 10:
            guard let tempStr: String = textField.text, textField.text != "" else{
                hit = 0
                break
            }
            hit = Int(tempStr)!
            break
        case 11:
            guard let tempStr: String = textField.text, textField.text != "" else{
                def = 0
                break
            }
            def = Int(tempStr)!
            break
        case 12:
            guard let tempStr: String = textField.text, textField.text != "" else{
                res = 0
                break
            }
            res = Int(tempStr)!
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
                
                name = editItem.itemName!
                textField.text = editItem.itemName
                
                break
                
            case 2:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                itemNo = Int(editItem.itemNo)
                textField.text = String(editItem.itemNo)
                
                break
                
            case 3:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                type = editItem.type!
                textField.text = editItem.type
                
                break
                
            case 4:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                flavorText = editItem.flavorText!
                textField.text = editItem.flavorText
                
                break
                
            case 5:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                hp = Int(editItem.hp)
                textField.text = String(editItem.hp)
                
                break
                
            case 6:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                ap = Int(editItem.ap)
                textField.text = String(editItem.ap)
                
                break
            case 7:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                apr = Int(editItem.apr)
                textField.text = String(editItem.apr)
                
                break
                
            case 8:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                atk = Int(editItem.atk)
                textField.text = String(editItem.atk)
                
                break
            case 9:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                intl = Int(editItem.intl)
                textField.text = String(editItem.intl)
                
                break
                
            case 10:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                hit = Int(editItem.hit)
                textField.text = String(editItem.hit)
                
                break
                
            case 11:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                def = Int(editItem.def)
                textField.text = String(editItem.def)
                
                break
                
            case 12:
                let textField:UITextField = self.view.viewWithTag(i) as! UITextField!
                
                res = Int(editItem.res)
                textField.text = String(editItem.res)
                
                break
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
