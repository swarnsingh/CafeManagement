//
//  OrderListViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 17/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OrderListViewController: UIViewController {
    
    @IBOutlet weak private var orderListTableView:UITableView!

    var orderListArray = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderListTableView.tableFooterView = UIView()
        
        self.title = "My Orders"
        
        self.getAllOrders()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllOrders(){
        
        let ref = Firestore.firestore().collection(Database.Collection.order.rawValue).whereField("user_info.id", isEqualTo: User.current.id).order(by: "status.Placed", descending: true)
        
        ref.getDocuments { (snapshot, error) in
            
            if error == nil{
                
                for document in (snapshot?.documents)!{
                    
                    self.orderListArray.append( Order(info: document.data()))
                    
                }
                
                self.orderListTableView.reloadData()
                
            }
            
        }
        
        
    }

}
