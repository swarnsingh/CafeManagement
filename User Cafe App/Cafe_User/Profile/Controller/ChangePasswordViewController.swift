//
//  ChangePasswordViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 14/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextfield:UITextField!
    @IBOutlet weak var newPasswordTextfield:UITextField!
    @IBOutlet weak var confirmNewPasswordTextfield:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Methods
    
    @IBAction func updatePasswordPressed(_ sender:UIButton){
        
        let textFields = [oldPasswordTextfield,newPasswordTextfield,confirmNewPasswordTextfield]
        
        for textField in textFields{
            
            if textField?.text?.count == 0{
                
                self.showAlert("Enter \(textField?.placeholder?.lowercased() ?? "")")
                return
            }
            
        }
        
        if !newPasswordTextfield.isValidPassword(){
            
            self.showAlert(ErrorMessage.invalidPassword.stringValue)
            return
        }
        
        if newPasswordTextfield.text != confirmNewPasswordTextfield.text{
            
            self.showAlert(ErrorMessage.passwordNotMatch.stringValue)
            return
        }
        
        try? Auth.auth().signOut()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Auth.auth().signIn(withEmail: User.current.email, password: oldPasswordTextfield.text!) { (user, error) in
            
            if user == nil{
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlert(ErrorMessage.incorrectPreviousPassword.stringValue)
                
            }else{
                
                user?.updatePassword(to: self.newPasswordTextfield.text!, completion: { (error) in
                    
                    if error == nil{
                        
                        try? Auth.auth().signOut()
                        
                        Auth.auth().signIn(withEmail: User.current.email, password: self.newPasswordTextfield.text!, completion: { (user, error) in
                            
                            MBProgressHUD.hide(for: self.view, animated: true)

                            if user != nil{
                                
                                self.showAlert(SuccessMessage.passwordChanged.stringValue, callback: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                                
                            }
                            
                        })
                        
                    }else{
                        
                        self.showAlert(error!.localizedDescription)
                        MBProgressHUD.hide(for: self.view, animated: true)

                    }
                    
                })
                
            }
            
        }
        
    }

}
