//
//  RegisterVC.swift
//  ITT Cafe
//
//  Created by Divyanshu Sharma on 20/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var confirmPasswordTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Methods
    
    @IBAction func signUpPressed(){
        
        self.checkValidation { result in
            
            if result.isValid{
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, err) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)

                    guard let error = err else {
                        
                        // user created
                        
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                        
                        self.showAlert(SuccessMessage.userCreated.stringValue, callback: {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        return
                    }
                    
                    self.showAlert(error.localizedDescription)
                    
                }
                
            }else{
                
                self.showAlert(result.error)
                
            }
            
        }
        
    }
    
    @IBAction func alreadyHaveAccountPressed(){
        
        self.navigationController?.popViewController(animated: true)
        
    }

}
