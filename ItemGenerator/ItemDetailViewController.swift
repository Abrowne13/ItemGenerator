//
//  ItemDetailViewController.swift
//  ItemGenerator
//
//  Created by Admin on 4/12/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var item: Item!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblItemNo: UILabel!
    @IBOutlet weak var lblFlavorText: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblHP: UILabel!
    @IBOutlet weak var lblAP: UILabel!
    @IBOutlet weak var lblAPR: UILabel!
    @IBOutlet weak var lblATK: UILabel!
    @IBOutlet weak var lblINTL: UILabel!
    @IBOutlet weak var lblHIT: UILabel!
    @IBOutlet weak var lblDEF: UILabel!
    @IBOutlet weak var lblRES: UILabel!
    @IBOutlet weak var lblEVA: UILabel!
    @IBOutlet weak var lblRNG: UILabel!
    @IBOutlet weak var lblMOV: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLablesWithItem()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setLablesWithItem(){
        lblTitle.text = item.itemName
        lblItemNo.text = String(item.itemNo)
        lblFlavorText.text = item.flavorText
        lblType.text = item.type
        lblHP.text = String(item.hp)
        lblAP.text = String(item.ap)
        lblAPR.text = String(item.apr)
        lblATK.text = String(item.atk)
        lblINTL.text = String(item.intl)
        lblHIT.text = String(item.hit)
        lblDEF.text = String(item.def)
        lblRES.text = String(item.res)
        lblEVA.text = String(item.eva)
        lblRNG.text = String(item.rng)
        lblMOV.text = String(item.mov)
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
