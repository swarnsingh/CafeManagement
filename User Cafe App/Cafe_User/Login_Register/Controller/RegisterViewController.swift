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
import FirebaseFirestore

class RegisterViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    @IBOutlet weak var confirmPasswordTextField:UITextField!
    @IBOutlet weak var phoneNumberTextField:UITextField!
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
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func allowedEmailButtonPressed(_ sender:UIButton){
        
        view.endEditing(true)
        pickerContainerView.isHidden = false
        pickerView.reloadComponent(0)
        
    }
    
    @IBAction func pickerButtonPressed(_ sender:UIBarButtonItem){
        
        pickerContainerView.isHidden = true

        if sender.tag == 101{
            
            // done pressed
            
            let selectedDomain = allowedEmailDomains[pickerView.selectedRow(inComponent: 0)]
            
            buttonAllowedDomain.setTitle("@"+selectedDomain, for: .normal)
            
        }

    }
    
    @IBAction func signUpPressed(){
        
        self.checkValidation { result in
            
            if result.isValid{
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                let email = self.emailTextField.text! + self.buttonAllowedDomain.titleLabel!.text!
                
                Auth.auth().createUser(withEmail: email, password: self.passwordTextField.text!) { (user, err) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    guard let error = err else {
                        
                        // user created
                        
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                        
                        let data = ["first_name":self.firstNameTextField.text!,
                                    "last_name":self.lastNameTextField.text!,
                                    "email":email,
                                    "mobile":self.phoneNumberTextField.text!] as [String : Any]
                        
                        let uID = user?.providerData.map{ $0.uid }
                        
                        Database.setDataAt(.user, With: uID!.first!, data: data)
                        
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
