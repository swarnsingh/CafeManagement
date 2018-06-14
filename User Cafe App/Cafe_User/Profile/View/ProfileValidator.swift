//
//  ProfileValidator.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 14/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
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
        
        let dbRef = Firestore.firestore().collection(Database.Collection.user.rawValue).document(User.current.id)
        
        let json = ["first_name":self.firstNameTextField.text!,
                    "last_name":self.lastNameTextField.text!,
                    "image":imagePath ?? ""]
        
        dbRef.setData(json, options: SetOptions.merge())
        
        self.showAlert(SuccessMessage.profileUpdated.stringValue, callback: {
            
            User.current.syncWithFirebase {}
            
            self.navigationController?.popViewController(animated: true)
            
        })
        
        
    }
    
}
