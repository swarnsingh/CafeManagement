//
//  HomeViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import DualSlideMenu
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var categoryListTableView:UITableView!
    
    var categoryArray = [Category]()
    
    var listner:ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryListTableView.tableFooterView = UIView()

        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: AppNotifications.productQtyChange.instance.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: AppNotifications.logout.instance.name, object: nil)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.addListners()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if User.current.state == .loggedOut{
         
            performSegue(withIdentifier: "login", sender: self)
            
        }
        
        self.updateBadge()
        
    }
    
    @objc func userDidLogout(){
        
        performSegue(withIdentifier: "login", sender: self)

    }
    
    //MARK: Button Methods

    @IBAction func sideMenuPressed(_ sender:UIButton){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.right.rawValue)
    }
    
    @IBAction func cartButtonPressed(_ sender:UIButton){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.left.rawValue)
        
    }
    
}
