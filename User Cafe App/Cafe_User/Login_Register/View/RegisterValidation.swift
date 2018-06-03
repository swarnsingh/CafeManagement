//
//  RegisterTextfieldValidation.swift
//  ITT Cafe
//
//  Created by Divyanshu Sharma on 20/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

extension RegisterViewController:UITextFieldDelegate{
    
    // MARK : Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let arrOfTextfield = [firstNameTextField,lastNameTextField,emailTextField,passwordTextField,confirmPasswordTextField]
        
        let indexOfTextField = arrOfTextfield.index{ $0 == textField }
        
        if indexOfTextField!+1 < arrOfTextfield.count{
            
            arrOfTextfield[indexOfTextField!+1]?.becomeFirstResponder()
            
        }else{
            
            self.view.endEditing(true)
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
    }
    
    // MARK : Validation Methods
    
    func checkValidation(result:(ValidationResult)->Void){
        
        if firstNameTextField.text?.count == 0{
            
            firstNameTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.emptyFirstName.stringValue,false))
            return
        }
        
        if lastNameTextField.text?.count == 0{
            
            lastNameTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.emptyLastName.stringValue,false))
            return

        }
        
        if emailTextField.text?.count == 0{
            
            emailTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.emptyEmail.stringValue,false))
            return

        }
        
        if !emailTextField.isValidEmail(){
            
            emailTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.invalidEmail.stringValue,false))
            return

        }
        
        if passwordTextField.text?.count == 0{
            
            passwordTextField.becomeFirstResponder()
            result(ValidationResult(ErrorMessage.emptyPassword.stringValue,false))
            return

        }
        
        if !passwordTextField.isValidPassword(){
            
            passwordTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.invalidPassword.stringValue,false))
            
            return
        }
        
        if passwordTextField.text != confirmPasswordTextField.text{
            
            passwordTextField.becomeFirstResponder()

            result(ValidationResult(ErrorMessage.passwordNotMatch.stringValue,false))
            return

        }
        
        result(ValidationResult("",true))
        
    }
    
}
