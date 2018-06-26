//
//  LoginValidation.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController{
        
    func checkValidation(result:(ValidationResult)->Void){
        
        if emailTextField.text?.count == 0{
            
           emailTextField.becomeFirstResponder()
            
            result(ValidationResult(ErrorMessage.emptyEmail.stringValue,false))
            
            return

        }
        
        let email = emailTextField.text! + (buttonAllowedDomain.titleLabel?.text!)!
        
        if !email.isValidEmail(){
            
            emailTextField.becomeFirstResponder()
            
            result(ValidationResult(ErrorMessage.invalidEmail.stringValue,false))
            return

        }
        
        if passwordTextField.text?.count == 0{
            
            passwordTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.emptyPassword.stringValue,false))
            return

        }
        
        result(ValidationResult("",true))
        
    }
    
    
}
