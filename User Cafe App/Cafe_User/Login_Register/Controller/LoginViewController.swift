//
//  LoginVC.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Methods
    
    @IBAction private func signInPressed(){
        
        self.checkValidation { result in
            
            if result.isValid{
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    guard let signInError = error else{
                        
                        if !(user?.isEmailVerified)!{
                            
                            self.showAlert(ErrorMessage.verifyEmail.stringValue)
                            try? Auth.auth().signOut()
                            return
                        }
                        
                        let uID = user?.providerData.map{ $0.uid }
                        
                        User.current.id = uID!.first!
                        
                        User.current.syncWithFirebase {
                            
                            self.navigationController?.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        return
                        
                    }
                    
                    self.showAlert(signInError.localizedDescription)
                    
                })
                
            }else{
                
                self.showAlert(result.error)
                
            }
            
        }
        
        
    }
    
}
