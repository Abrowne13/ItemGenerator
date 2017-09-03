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
        lblAbilityID.text = ability.value(forKey: "abilityID") as! String?
        lblAbilityDescription.text = ability.abilityDescription
        lblAbilityApCost.text = ability.value(forKey: "apCost") as! String?
        lblAbilityBaseEffect.text = ability.value(forKey: "baseEffect") as! String?
        lblAbilityRatioEffect.text = ability.value(forKey: "ratioEffect") as! String?
        lblAbilityTargetType.text = ability.targetType
        lblAbilityRange.text = ability.value(forKey: "range") as! String?
        lblAbilityRadius.text = ability.value(forKey: "radius") as! String?
    }

}
