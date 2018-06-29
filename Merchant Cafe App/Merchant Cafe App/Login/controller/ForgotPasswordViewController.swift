//
//  ForgotPasswordViewController.swift
//  Merchant Cafe App
//
//  Created by Umang Gupta on 12/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var submitButton: CustomButton!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButtonPressed(_ sender: CustomButton) {
       
        if emailTextField.text?.count == 0{
            
            self.showAlert("Empty Email", ErrorMessage.emptyEmail.stringValue)
            return
        }
        
        if !emailTextField.isValidEmail(){
            self.showAlert("Invalid Email", ErrorMessage.invalidEmail.stringValue)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard let errorOfPasswordReset = error else {
                
                self.showAlert(SuccessMessage.passwordResetMail.stringValue, callback: {
                    self.dismiss(animated: true, completion: nil)
                })
                return
            }
            
            self.showAlert("Error!", errorOfPasswordReset.localizedDescription)
            
        })
        
    }
}
