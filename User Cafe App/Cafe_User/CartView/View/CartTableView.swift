//
//  CartTableView.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 31/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension CartViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartProductArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let cartProduct = cartProductArray[indexPath.section]

        
        let labelName = cell.viewWithTag(101) as! UILabel
        let labelCategory = cell.viewWithTag(102) as! UILabel
        let labelPrice = cell.viewWithTag(103) as! UILabel
        let labelCount = cell.viewWithTag(104) as! UILabel

        let addButton = cell.viewWithTag(106) as! UIButton
        let minusButton = cell.viewWithTag(107) as! UIButton
        let deleteButton = cell.viewWithTag(108) as! UIButton
        
        
        addButton.addTarget(self, action: #selector(productQtyButtonPressed(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(productQtyButtonPressed(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(productQtyButtonPressed(_:)), for: .touchUpInside)
        
        let imageProduct = cell.viewWithTag(105) as! UIImageView
        
        labelName.text = cartProduct.name
        labelCategory.text = cartProduct.category_name
        labelPrice.text = "₹ \(cartProduct.price)"
        labelCount.text = "\(cartProduct.addedQty)"
        
        guard let image = cartProduct.image else { return cell }
        
        let url = URL(string:image)!
        
        imageProduct.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
