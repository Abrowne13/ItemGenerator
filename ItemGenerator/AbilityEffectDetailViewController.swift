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
        for attribute in attributes{
            keys.add(attribute.key)
        }
        
        for case let title as String in keys{
            if(title == "name"){
                continue
            }
            else if(title == "procRate"){
                procLabel.text = "procRate"
            }
            else{
                if(attribute3Label.text == "Label"){
                    attribute3Label.text = title
                    attribute3Label.isHidden = false
                    attribute3TextField.isHidden = false
                    continue
                }
                if(attribute4Label.text == "Label"){
                    attribute4Label.text = title
                    attribute4Label.isHidden = false
                    attribute4TextField.isHidden = false
                    continue
                }
                if(attribute5Label.text == "Label"){
                    attribute5Label.text = title
                    attribute5Label.isHidden = false
                    attribute5TextField.isHidden = false
                    continue
                }
                if(attribute6Label.text == "Label"){
                    attribute6Label.text = title
                    attribute6Label.isHidden = false
                    attribute6TextField.isHidden = false
                    continue
                }
            }
        }
        
        
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: abilityEffectName)
        let sortDescript : NSSortDescriptor = NSSortDescriptor.init(key: "name", ascending: true)
        let sortDescripts = [sortDescript]
        fetchRequest.sortDescriptors = sortDescripts
        
        do {
            abilityEffects = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for entries in abilityEffects{
            self.pickerRows?.add(entries.value(forKey: "name") ?? "")
        }
        self.pickerRows.add("Add Entry")
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
