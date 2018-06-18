//
//  OrderDetailViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak private var productListTableView:UITableView!

    @IBOutlet weak private var orderPriceLabel:UILabel!
    @IBOutlet weak private var orderIDLabel:UILabel!
    @IBOutlet weak private var orderStatusLabel:UILabel!
    @IBOutlet weak private var orderItemQtyLabel:UILabel!
    @IBOutlet weak private var orderDateLabel:UILabel!
    @IBOutlet weak private var orderOTPLabel:UILabel!

    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productListTableView.tableFooterView = UIView()

        orderPriceLabel.text = "\(order.price)"
        orderStatusLabel.text = order.status.rawValue
        orderItemQtyLabel.text = "\(order.products.count) Items"
        orderDateLabel.text = order.placedAt
        orderIDLabel.text = "#\(order.id)"
        orderStatusLabel.textColor = order.status.color
        orderOTPLabel.text = order.otp
        
        self.title = "Order Detail"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
