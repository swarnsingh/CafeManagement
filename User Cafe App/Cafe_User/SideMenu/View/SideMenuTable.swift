//
//  SideMenuTable.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource{
    
    static private let menuOptions = ["My Account","My Orders","Logout"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let labelCell = cell?.viewWithTag(101) as! UILabel
        labelCell.text = SideMenuViewController.menuOptions[indexPath.row]
        
        cell?.selectionStyle = .none

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.right.rawValue)

        let navController = Constants.sideMenuController.mainView as! UINavigationController
        
        switch indexPath.row {
        case 0:
            
            let profileVC = AppStoryBoard.Login.instance.instantiateViewController(withIdentifier: "ProfileViewController")
            
            navController.pushViewController(profileVC, animated: true)
            
        case 1:
            break
        case 2:
            
            self.showAlertController(.alert, title: "Alert", text: "Are you sure to logout?", options: ["Logout"], callback: { tappedIndex in
                
                if tappedIndex == 0{
                    
                    User.current.logout()
                    
                    NotificationCenter.default.post(AppNotifications.logout.instance)
                    
                }
                
            })
            
        default:
            break
        }
        
    }
    
}
