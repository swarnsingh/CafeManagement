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
    
    @IBOutlet var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
      //  self.profileImageView.clipsToBounds = true
      //  self.profileImageView.layer.borderWidth = 3.0
        //self.profileImageView.layer.borderColor = (UIColor.white as! CGColor)
        
        logoutMenuButton.addTarget(self, action: #selector(self.onLogout(_:)), for: .touchUpInside)
        categoryMenuButton.addTarget(self, action: #selector(self.onCategoryPress(_:)), for: .touchUpInside)
        productMenuButton.addTarget(self, action: #selector(self.onProductClick(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    private func goToController(controller: String, nextViewController : AnyClass) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: controller)
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func onLogout(_ sender: Any) {
        PreferenceManager.setUserLogin(isUserLogin: false)
        self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
    }
    
    @IBAction func onCategoryPress(_ sender: UIButton){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryProductViewController") as! CategoryProductViewController
        nextViewController.isFromCategory = true
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        sideMenuController?.hideMenu()
        
    }
    
    @IBAction func onProductClick(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryProductViewController") as! CategoryProductViewController
        //nextViewController.isFromCategory = true
        
        (self.sideMenuController?.contentViewController as! UINavigationController).pushViewController(nextViewController, animated: true)
        sideMenuController?.hideMenu()
  
    }
    
    
    
    

}
