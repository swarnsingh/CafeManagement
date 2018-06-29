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
import FirebaseMessaging
import MBProgressHUD

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
        
        totalPriceLabel.text = "\(Constants.config.currency) \(totalPrice)"
        
        totalItemLabel.text = "\(cartProductArray.count) Item"
        
    }
    
    func placeOrder(){
        
        let totalPrice = cartProductArray.map{$0.price*Double($0.addedQty)}.reduce(0.0, +)
        
        if totalPrice > 10_000{
            
            self.showAlert(InfoMessage.orderPriceLimitReached.stringValue)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let objectID = Firestore.firestore().collection(Database.Collection.order.rawValue).document().documentID.encodeValue
        
        let orderObject = Firestore.firestore().collection(Database.Collection.order.rawValue).document(objectID)
        
        let status = [Order.Status.Placed.rawValue:FieldValue.serverTimestamp()]
        
        let orderValue = [ "order_id":objectID,
                           "order_price":totalPrice,
                           "products":cartProductArray.map{$0.jsonRepresentation},
                           "user_info":User.current.jsonRepresentation,
                           "status":status,
                           "otp":Constants.generateOTP(),
                           "contact_detail":Constants.config.contactPhone] as [String : Any]
        
        orderObject.setData(orderValue) { (error) in
            
            if error == nil{
                
                for product in self.cartProductArray{
                    product.remove()
                }
                
                NotificationCenter.default.post(AppNotifications.productQtyChange.instance)
                
                self.fetchSavedCartProducts()
                
                self.showAlert(SuccessMessage.orderPlaced.stringValue)
                
                let ref = Firestore.firestore().collection(Database.Collection.order.rawValue).document(objectID)
                
                ref.getDocument(completion: { (document, error) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let order = Order(info: document!.data()!)
                    
                    let orderDetailVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
                    
                    orderDetailVC.order = order
                    
                    Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.left.rawValue)
                    
                    let navController = Constants.sideMenuController.mainView as! UINavigationController
                    
                    navController.pushViewController(orderDetailVC, animated: true)
                    
                })
                
            }else{
                
                MBProgressHUD.hide(for: self.view, animated: true)

                self.showAlert(error!.localizedDescription)
                
            }
            
        }

    }
    
}

extension String{
    
    var encodeValue:String{
        
        var uniqueID = 0
        
        for char in self{
            
            let charSet = CharacterSet(charactersIn: "\(char)")
            
            if charSet.isSubset(of: CharacterSet.decimalDigits){
                
                uniqueID += Int("\(char)")!
                
            }else{
                
                uniqueID += Int(char.unicodeScalars.first?.value ?? 0)
                
            }
            
        }
        
        return "\(uniqueID)"
        
    }
    
}
