//
//  ViewController.swift
//  ItemGenerator
//
//  Created by Admin on 4/3/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var tableItemList: UITableView!

    @IBOutlet weak var searchBarItemList: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Item List"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Search Bar Delegate calls
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarItemList.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarItemList.showsCancelButton = false
        searchBar.resignFirstResponder();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
    }
    
    //Table View Delegate calls
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

}

