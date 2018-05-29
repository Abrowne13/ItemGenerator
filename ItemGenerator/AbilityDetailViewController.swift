//
//  AbilityDetailViewController.swift
//  ItemGenerator
//
//  Created by Admin on 9/9/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailViewController: UIViewController {
    
    var ability: Ability!

    @IBOutlet weak var lblAbilityName: UILabel!
    @IBOutlet weak var lblAbilityID: UILabel!
    @IBOutlet weak var lblAbilityModifierType: UILabel!
    @IBOutlet weak var lblAbilityAPCost: UILabel!
    @IBOutlet weak var lblAbilityTargetType: UILabel!
    @IBOutlet weak var lblAbilityBaseValue: UILabel!
    @IBOutlet weak var lblAbilityRatioValue: UILabel!
    @IBOutlet weak var lblAbilityRange: UILabel!
    @IBOutlet weak var lblAbilityRadius: UILabel!
    @IBOutlet weak var lblAbilityLevelUnlock: UILabel!
    @IBOutlet weak var lblAbilityAnimationTime: UILabel!
    @IBOutlet weak var lblAbilityDescription: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLabelsWithAbility()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setLabelsWithAbility(){
        lblAbilityName.text = ability.name
        lblAbilityID.text = String(ability.abilityID)
        lblAbilityModifierType.text = ability.modifierType
        lblAbilityAPCost.text = String(ability.apCost)
        lblAbilityTargetType.text = ability.targetType
        lblAbilityBaseValue.text = String(ability.baseValue)
        lblAbilityRatioValue.text = String(ability.ratioValue)
        lblAbilityRange.text = String(ability.range)
        lblAbilityRadius.text = String(ability.radius)
        lblAbilityLevelUnlock.text = String(ability.levelUnlock)
        lblAbilityAnimationTime.text = String(ability.animationTime)
        lblAbilityDescription.text = ability.abilityDescription
    }
    
    @IBAction func pushedEditButton(_ sender: Any) {
        
        let addAbility : AddAbilityViewController = self.storyboard!.instantiateViewController(withIdentifier:"addAbility") as! AddAbilityViewController
        //The item list and the selected table cell row will likely desync
        addAbility.editMode = true
        addAbility.editAbility = ability
        self.navigationController!.pushViewController(addAbility, animated: true)
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
