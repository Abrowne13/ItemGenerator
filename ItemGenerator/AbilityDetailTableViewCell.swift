//
//  AbilityDetailTableViewCell.swift
//  ItemGenerator
//
//  Created by Admin on 10/21/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit


protocol AbilityDetailSwitchDelegate: AnyObject {
    func didToggleSwitch(_ sender: AbilityDetailTableViewCell)
}

class AbilityDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var abilityDetailTextField: UITextField!
    
    @IBOutlet weak var abilityDetailLabel: UILabel!

    @IBOutlet weak var abilityDetailSwitch: UISwitch!
    
    weak var delegate: AbilityDetailSwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        abilityDetailTextField.isHidden = true
        abilityDetailSwitch.isHidden = true
        self.selectionStyle = .none
    }

    @IBAction func valueChanged(_ sender: Any) {
        delegate?.didToggleSwitch(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
