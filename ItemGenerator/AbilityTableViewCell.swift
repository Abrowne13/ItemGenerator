//
//  AbilityTableViewCell.swift
//  ItemGenerator
//
//  Created by Admin on 9/3/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityTableViewCell: UITableViewCell {
    
    var ability : Ability!
    
    @IBOutlet weak var lblAbilityName: UILabel!
    @IBOutlet weak var lblAbilityDescription: UILabel!
    @IBOutlet weak var lblAbilityID: UILabel!
    @IBOutlet weak var lblAbilityApCost: UILabel!
    @IBOutlet weak var lblAbilityBaseValue: UILabel!
    @IBOutlet weak var lblAbilityRatioValue: UILabel!
    @IBOutlet weak var lblAbilityTargetType: UILabel!
    @IBOutlet weak var lblAbilityRange: UILabel!
    @IBOutlet weak var lblAbilityRadius: UILabel!
    @IBOutlet weak var viewAbilityColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelsWithAbility(){
        lblAbilityName.text = ability.name
        let abilityNo : Int = ability.value(forKey: "abilityID") as? Int ?? 0
        lblAbilityID.text = String(abilityNo)
        lblAbilityDescription.text = ability.abilityDescription
        let apCost : Int = ability.value(forKey: "apCost") as? Int ?? 0
        lblAbilityApCost.text = String(apCost)
        let baseValue : Int = ability.value(forKey: "baseValue") as? Int ?? 0
        lblAbilityBaseValue.text = String(baseValue)
        let ratioValue : Float = ability.value(forKey: "ratioValue") as? Float ?? 0
        lblAbilityRatioValue.text = String(ratioValue)
        lblAbilityTargetType.text = ability.targetType
        let range : Int = ability.value(forKey: "range") as? Int ?? 0
        lblAbilityRange.text = String(range)
        let radius : Int = ability.value(forKey: "radius") as? Int ?? 0
        lblAbilityRadius.text = String(radius)
    }

}
