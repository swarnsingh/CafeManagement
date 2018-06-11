//
//  CartViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 31/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    var cartProductArray = [CartProduct]()
    
    @IBOutlet weak var totalItemLabel:UILabel!

    @IBOutlet weak var totalPriceLabel:UILabel!

    @IBOutlet weak var checkoutButton:UIButton!

    @IBOutlet weak var cartProductTableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        cartProductTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSavedCartProducts), name: AppNotifications.productQtyChange.instance.name, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchSavedCartProducts()

    }
    
    //MARK:Button Methods
    
    @IBAction func checkoutButtonPressed(_ sender:UIButton){
        
        self.showAlertController(.alert, title: "Checkout", text: "Confirm checkout?", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0{
                
                self.placeOrder()
                
            }
            
        }
        
    }
    
    @objc func productQtyButtonPressed(_ sender:UIButton){
        
        let touchLocation = sender.convert(CGPoint.zero, to: cartProductTableView)
        
        let index = cartProductTableView.indexPathForRow(at: touchLocation)
        
        guard let indexPath = index else {return}
        
        let cartProduct = cartProductArray[indexPath.section]
        
        switch sender.tag {
        case 106:
            // add product
            
            cartProduct.addedQty+=1
            
        case 107:
            
            cartProduct.addedQty-=1
            
            if cartProduct.addedQty == 0{
                
                cartProduct.remove()
                
            }
            
        case 108:
            
            cartProduct.remove()
            
            
        default:
            break
        }
        
        cartProduct.save()
        
        self.fetchSavedCartProducts()
        
        NotificationCenter.default.post(AppNotifications.productQtyChange.instance)
        
    }

}
