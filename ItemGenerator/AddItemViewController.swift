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
        
        let item = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        var errorMsg : String = "Check the following fields:\n"
        var hasError : Bool = false
        
        // 3 //All the fun error handling and ect here...
        if (name == "") {
            print("Boo...")
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
            try managedContext.save()
            itemList.append(item)
            let navController = self.navigationController!
            navController.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        
        //Textfield tags 4-14 are the stats
        
        switch textField.tag {
        case 0:
            name = textField.text!
            break
        case 1:
            guard let tempStr: String = textField.text, textField.text != "" else{
                itemNo = -1
                break
            }
            itemNo = Int(tempStr)!
            break
        case 2:
            type = textField.text!
            break
        case 3:
            flavorText = textField.text!
            break
        case 4:
            guard let tempStr: String = textField.text, textField.text != "" else{
                hp = 0
                break
            }
            hp = Int(tempStr)!
            break
        case 5:
            guard let tempStr: String = textField.text, textField.text != "" else{
                ap = 0
                break
            }
            ap = Int(tempStr)!
            break
        case 6:
            guard let tempStr: String = textField.text, textField.text != "" else{
                apr = 0
                break
            }
            apr = Int(tempStr)!
            break
        case 7:
            guard let tempStr: String = textField.text, textField.text != "" else{
                atk = 0
                break
            }
            atk = Int(tempStr)!
            break
        case 8:
            guard let tempStr: String = textField.text, textField.text != "" else{
                intl = 0
                break
            }
            intl = Int(tempStr)!
            break
        case 9:
            guard let tempStr: String = textField.text, textField.text != "" else{
                hit = 0
                break
            }
            hit = Int(tempStr)!
            break
        case 10:
            guard let tempStr: String = textField.text, textField.text != "" else{
                def = 0
                break
            }
            def = Int(tempStr)!
            break
        case 11:
            guard let tempStr: String = textField.text, textField.text != "" else{
                res = 0
                break
            }
            res = Int(tempStr)!
            break
        case 12:
            guard let tempStr: String = textField.text, textField.text != "" else{
                eva = 0
                break
            }
            eva = Int(tempStr)!
            break
        case 13:
            guard let tempStr: String = textField.text, textField.text != "" else{
                rng = 1
                break
            }
            mov = Int(tempStr)!
            break
        case 14:
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
