//
//  ItemTableViewCell.swift
//  ItemGenerator
//
//  Created by Admin on 4/10/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblFlavorText: UILabel!
    @IBOutlet weak var lblItemType: UILabel!
    @IBOutlet weak var lblItemNumber: UILabel!
    
    @IBOutlet weak var viewItemColor: UIView!
    var item : Item!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelsWithItem(){
        self.lblItemName.text = item.value(forKey: "itemName") as! String?
        self.lblFlavorText.text = item.value(forKey: "flavorText") as! String?
        self.lblItemType.text = item.value(forKey: "type") as! String?
        let itemNo : Int = item.value(forKey: "itemNo") as! Int
        self.lblItemNumber.text = String(itemNo)
    }

}
