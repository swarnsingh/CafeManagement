//
//  OrderListTableView.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

extension OrderListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderListArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let order = orderListArray[indexPath.section]
        
        let orderIDLabel = cell.viewWithTag(101) as! UILabel
        let orderDateLabel = cell.viewWithTag(102) as! UILabel
        let orderPriceLabel = cell.viewWithTag(103) as! UILabel
        let orderStatusLabel = cell.viewWithTag(104) as! UILabel
        let orderProductCountLabel = cell.viewWithTag(105) as! UILabel

        orderIDLabel.text = "#" + order.id
        orderPriceLabel.text = "₹ \(order.price)"
        orderStatusLabel.text = order.status.rawValue
        orderDateLabel.text = order.placedAt
        orderProductCountLabel.text = "\(order.products.count) item"
        orderStatusLabel.textColor = order.status.color
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        detailVC.order = orderListArray[indexPath.section]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}
