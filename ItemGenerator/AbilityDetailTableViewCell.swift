//
//  AbilityDetailTableViewCell.swift
//  ItemGenerator
//
//  Created by Admin on 10/21/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class AbilityDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var abilityDetailTextField: UITextField!
    
    @IBOutlet weak var abilityDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        abilityDetailTextField.isHidden = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
