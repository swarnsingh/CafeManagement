//
//  ProfileValidator.swift
//  Cafe_User
//
//  Created by Umang Gupta on 14/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

extension ProfileViewController{
    
    typealias ValidationResult = (isValid:Bool,error:String)
    
    func validate(completionHadler:(ValidationResult)->Void){
        
        if firstNameTextField.text?.count == 0{
            
            completionHadler((false,ErrorMessage.emptyFirstName.stringValue))
            
        }else if lastNameTextField.text?.count == 0{
            
            completionHadler((false,ErrorMessage.emptyLastName.stringValue))
            
        }else{
            
            completionHadler((true,""))
            
        }
        
    }
    
    func updateData(){

        let dbRef = Firestore.firestore().collection(Database.Collection.config.rawValue)
        
        dbRef.getDocuments { (snapshot, error) in
            
            if error == nil{
                
                let document = snapshot?.documents.first
                
                var admins = document?.data()["admins"] as? [[String:Any]] ?? [[:]]
                
                var me = admins.filter{$0["email"] as! String == self.emailTextField.text!}.first!
                
                me["first_name"] = self.firstNameTextField.text!
                me["last_name"] = self.lastNameTextField.text!
                me["image"] = self.imagePath ?? ""
                
                let index = admins.index(where: { (info) -> Bool in
                    return info["email"] as! String == self.emailTextField.text!
                })
                
                admins.remove(at: index!)
                admins.append(me)
                
                var data = document?.data()
                data!["admins"] = admins
                
                document?.reference.setData(data!, merge: true)
                
                self.showAlert("profile Updated Successfully", callback: {
                    
                    User.current.syncWithFirebase {}
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
                
            }
            
        }
        
    }
    
}
