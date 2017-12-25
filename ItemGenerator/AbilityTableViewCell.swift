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
    @IBOutlet weak var lblAbilityBaseEffect: UILabel!
    @IBOutlet weak var lblAbilityRatioEffect: UILabel!
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
        let baseEffect : Int = ability.value(forKey: "baseEffect") as? Int ?? 0
        lblAbilityBaseEffect.text = String(baseEffect)
        let ratioEffect : Float = ability.value(forKey: "ratioEffect") as? Float ?? 0
        lblAbilityRatioEffect.text = String(ratioEffect)
        lblAbilityTargetType.text = ability.targetType
        let range : Int = ability.value(forKey: "range") as? Int ?? 0
        lblAbilityRange.text = String(range)
        let radius : Int = ability.value(forKey: "radius") as? Int ?? 0
        lblAbilityRadius.text = String(radius)
    }

}
