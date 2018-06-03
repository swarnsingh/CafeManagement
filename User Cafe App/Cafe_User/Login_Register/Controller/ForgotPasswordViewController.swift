//
//  ForgotPasswordViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 31/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Methods
    
    @IBAction func backButtonPressed(_ sender:UIButton){
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func submitButtonPressed(_ sender:UIButton){
        
        if emailTextField.text?.count == 0{
            
            self.showAlert(ErrorMessage.emptyEmail.stringValue)
            return
        }
        
        if !emailTextField.isValidEmail(){
            
            self.showAlert(ErrorMessage.invalidEmail.stringValue)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            guard let errorOfPasswordReset = error else {
                
                self.showAlert(SuccessMessage.passwordResetMail.stringValue, callback: {
                    self.navigationController?.popViewController(animated: true)
                })
                return
            }
            
            self.showAlert(errorOfPasswordReset.localizedDescription)
            
        })
        
    }
    

}
