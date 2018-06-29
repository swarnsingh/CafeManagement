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
import FirebaseFirestore

class LoginViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak private var pickerView:UIPickerView!
    @IBOutlet weak private var pickerContainerView:UIView!
    @IBOutlet weak var buttonAllowedDomain:UIButton!
    
    var allowedEmailDomains = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firestore.firestore().collection(Database.Collection.config.rawValue).getDocuments { (snapshot, error) in
            
            if error == nil{
                
                let document = snapshot?.documents.first!
                
                self.allowedEmailDomains = document?.data()["allowed_domains"] as? [String] ?? []
                
                self.buttonAllowedDomain.setTitle("@" + self.allowedEmailDomains.first!, for: .normal)
                
                self.pickerView.reloadComponent(0)

            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: PickerView Methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allowedEmailDomains.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allowedEmailDomains[row]
    }
    
    // MARK: Button Methods
    
    @IBAction private func allowedEmailButtonPressed(_ sender:UIButton){
        
        view.endEditing(true)
        pickerContainerView.isHidden = false
        pickerView.reloadComponent(0)
        
    }
    
    @IBAction private func pickerButtonPressed(_ sender:UIBarButtonItem){
        
        pickerContainerView.isHidden = true
        
        if sender.tag == 101{
            
            // done pressed
            
            let selectedDomain = allowedEmailDomains[pickerView.selectedRow(inComponent: 0)]
            
            buttonAllowedDomain.setTitle("@"+selectedDomain, for: .normal)
            
        }
        
    }
    
    @IBAction private func signInPressed(){
        
        self.checkValidation { result in
            
            if result.isValid{
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let email = self.emailTextField.text! + self.buttonAllowedDomain.titleLabel!.text!
                
                Auth.auth().signIn(withEmail: email, password: passwordTextField.text!, completion: { (user, error) in
                    
                    guard let signInError = error else{
                        
                        if !(user?.isEmailVerified)!{
                            
                            self.showAlert(ErrorMessage.verifyEmail.stringValue)
                            try? Auth.auth().signOut()
                            MBProgressHUD.hide(for: self.view, animated: true)
                            return
                            
                        }
                        
                        let uID = user?.providerData.map{ $0.uid }
                        
                        User.current.id = uID!.first!
                        
                        User.current.syncWithFirebase {
                            
                            User.current.updateDeviceInfo()
                            
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.navigationController?.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        return
                        
                    }
                    
                    MBProgressHUD.hide(for: self.view, animated: true)

                    self.showAlert(signInError.localizedDescription)
                    
                })
                
            }else{
                
                self.showAlert(result.error)
                
            }
            
        }
        
        
    }
    
}
