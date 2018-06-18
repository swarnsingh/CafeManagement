//
//  OrderDetailTableView.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

extension OrderDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.products.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if indexPath.row > 0{
            
            let product = order.products[indexPath.row-1]
            
            let productNameLabel = cell.viewWithTag(101) as! UILabel
            
            let productQTYLabel = cell.viewWithTag(102) as! UILabel
            
            let productPriceLabel = cell.viewWithTag(103) as! UILabel
            
            productNameLabel.text = product.name
            productQTYLabel.text = "\(product.addedQty)x"
            productPriceLabel.text = "₹ \(product.price)"
            
        }

        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}
