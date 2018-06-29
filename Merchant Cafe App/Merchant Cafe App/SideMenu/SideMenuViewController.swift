//
//  SideMenuViewController.swift
//  Merchant Cafe App
//
//  Created by Umang Gupta on 01/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import UIKit
import SideMenuSwift
class SideMenuViewController: UIViewController {
    
    @IBOutlet var logoutMenuButton: UIButton!
    @IBOutlet var categoryMenuButton: UIButton!
    @IBOutlet var productMenuButton: UIButton!
    @IBOutlet var orderHistoryButton: UIButton!
    @IBOutlet var myProfileButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutMenuButton.addTarget(self, action: #selector(self.onLogout(_:)), for: .touchUpInside)
        categoryMenuButton.addTarget(self, action: #selector(self.onCategoryPress(_:)), for: .touchUpInside)
        productMenuButton.addTarget(self, action: #selector(self.onProductClick(_:)), for: .touchUpInside)
        
    }
    
    private func goToController(controller: String, nextViewController : AnyClass) {
        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Main.rawValue, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: controller)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.showAlertController(.alert, title: "Log Out", text: "Are you sure you want to Logout?", options: ["Yes"]) { (tappedIndex) in
            
            if tappedIndex == 0 {
                PreferenceManager.setUserLogin(isUserLogin: false)
                self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
                Constants.sideMenu.hideMenu()
            }
        }
    }
    
    @IBAction func onCategoryPress(_ sender: UIButton){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Main.rawValue, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.CATEGORY_PRODUCT_SEGUE) as! CategoryProductViewController
        nextViewController.isFromCategory = true
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        Constants.sideMenu.hideMenu()
        
    }
    
    @IBAction func onProductClick(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Main.rawValue, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.CATEGORY_PRODUCT_SEGUE) as! CategoryProductViewController
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        Constants.sideMenu.hideMenu()
        
    }
    
    @IBAction func onMyProfilePress(_ sender: Any) {

        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Main.rawValue, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.PROFILE_VIEW_SEGUE) as! ProfileViewController
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        Constants.sideMenu.hideMenu()
    }
    
    @IBAction func onOrderHistoryPress(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: AppStoryBoard.Reports.rawValue, bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Constants.REPORTS_VIEW_SEGUE) as! MerchantReportViewController
        
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        Constants.sideMenu.hideMenu()
    }
    
}
