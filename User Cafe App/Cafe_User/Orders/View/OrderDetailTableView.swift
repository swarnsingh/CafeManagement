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
        return order.products.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let product = order.products[indexPath.row]
        
        let productNameLabel = cell.viewWithTag(101) as! UILabel
        
        let productQTYLabel = cell.viewWithTag(102) as! UILabel
        
        let productPriceLabel = cell.viewWithTag(103) as! UILabel
        
        productNameLabel.text = product.name
        productQTYLabel.text = "\(product.addedQty)x"
        productPriceLabel.text = "\(Constants.config.currency) \(product.price)"
        
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
}
