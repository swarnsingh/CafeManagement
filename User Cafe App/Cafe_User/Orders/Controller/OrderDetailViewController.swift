//
//  OrderDetailViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrderDetailViewController: UIViewController {

    @IBOutlet weak private var productListTableView:UITableView!
    @IBOutlet weak private var orderPriceLabel:UILabel!
    @IBOutlet weak private var orderIDLabel:UILabel!
    @IBOutlet weak private var orderStatusLabel:UILabel!
    @IBOutlet weak private var orderItemQtyLabel:UILabel!
    @IBOutlet weak private var orderDateLabel:UILabel!
    @IBOutlet weak private var orderOTPLabel:UILabel!
    @IBOutlet weak private var cancelOrderButton:UIButton!
    @IBOutlet weak private var callButton:UIButton!

    var delegate:OrderDetailDelegate!
    
    var order:Order!
    
    var orderStatusObserver:ListenerRegistration?
    
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
        cancelOrderButton.isHidden = order.status != .Placed
        callButton.setTitle(order.contactDetail, for: .normal)
        
        self.title = "Order Detail"
        
        self.observeOrderStatus()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let orderObserver = orderStatusObserver else {return}
        
        orderObserver.remove()
        
    }
    
    func observeOrderStatus(){
        
        if order.status == .Placed{
            
            orderStatusObserver = Firestore.firestore().collection(Database.Collection.order.rawValue).document(order.id).addSnapshotListener { (snapshot, error) in
                
                if error == nil && (snapshot?.exists)!{
                    
                    let order = Order(info: (snapshot!.data())!)
                    
                    self.cancelOrderButton.isHidden = order.status != .Placed
                    self.orderStatusLabel.textColor = order.status.color
                    self.orderStatusLabel.text = order.status.rawValue
                    
                }
                
                
            }
            
        }

        
    }
    
    //MARK: Button Methods
    
    @IBAction func callButtonPressed(_ sender:UIButton){
        
        let url = URL(string: "tel://\(order.contactDetail)")
        
        if UIApplication.shared.canOpenURL(url!){
            
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            
        }else{
            
            self.showAlert(ErrorMessage.callFailed.stringValue)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender:UIButton){
        
        self.showAlertController(.actionSheet, title: "Confirm?", text: InfoMessage.cancelOrderConfirm.stringValue, options: ["Cancel Order"]) { (tappedIndex) in
            
            if tappedIndex == 0{
                
                let ref = Firestore.firestore().collection(Database.Collection.order.rawValue).document(self.order.id)

                let status = ["status":["Cancelled":FieldValue.serverTimestamp()]]
                
                ref.setData(status, options: SetOptions.merge())
                
                if self.delegate != nil{
                    self.delegate.updateList()
                }
                
                self.showAlert(SuccessMessage.orderCancelled.stringValue, callback: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            
        }
        
    }
    
}

protocol OrderDetailDelegate {
    func updateList()
}
