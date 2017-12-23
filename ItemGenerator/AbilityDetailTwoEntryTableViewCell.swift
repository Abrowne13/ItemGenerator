//
//  AbilityDetailTwoEntryTableViewCell.swift
//  ItemGenerator
//
//  Created by Admin on 12/10/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailTwoEntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var abilityDetailLabel: UILabel!
    @IBOutlet weak var abilityDetailLeftTextField: UITextField!
    @IBOutlet weak var abilityDetailRightTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        abilityDetailLeftTextField.isHidden = true
        abilityDetailRightTextField.isHidden = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
