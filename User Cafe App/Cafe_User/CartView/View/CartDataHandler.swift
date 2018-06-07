//
//  CartDataHandler.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 01/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

extension CartViewController{
    
    @objc func fetchSavedCartProducts(){
        
        let context = Database.persistentContainer.viewContext
        
        let fetchRequest = CartProduct.request()

        let result = try? context.fetch(fetchRequest)
        
        guard let products = result else { return }
        
        cartProductArray = products.sorted(by: { (item1, item2) -> Bool in
            return item1.name!.localizedCaseInsensitiveCompare(item2.name!) == .orderedAscending
        })
        
        checkoutButton.isHidden = cartProductArray.count == 0
        
        cartProductTableView.isHidden = checkoutButton.isHidden
        
        totalItemLabel.superview?.isHidden = checkoutButton.isHidden
        
        calculateTotalPrice()
        
        cartProductTableView.reloadData()
        
    }
    
    func calculateTotalPrice(){
        
        let totalPrice = cartProductArray.map{$0.price*Double($0.addedQty)}.reduce(0.0, +)
        
        totalPriceLabel.text = "₹ \(totalPrice)"
        
        totalItemLabel.text = "\(cartProductArray.count) Item"
        
    }
    
    func placeOrder(){
        
        let totalOrderPrice = self.cartProductArray.map{$0.price}.reduce(0.0,+)
        
        let orderObject = Firestore.firestore().collection(Database.Collection.order.rawValue)
        
    }
    
}
