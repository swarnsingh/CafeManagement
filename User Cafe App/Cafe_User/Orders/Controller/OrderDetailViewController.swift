//
//  OrderDetailViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var productListTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productListTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
