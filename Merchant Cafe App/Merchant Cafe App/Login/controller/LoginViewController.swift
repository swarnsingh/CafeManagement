/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    
    @IBOutlet weak var loginButton: CustomButton!
    
    
    @IBOutlet weak var forgotPasswordLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isValidEmail(email:String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(password:String?) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        
        return passwordTest.evaluate(with: password!)
    }
    
    private func showAlert(message:String?) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func isLoginFieldValid(email:String?, password:String?) -> Bool {
        var isFieldsValid = true
        if (email == nil || email == "") {
            showAlert(message: "Please add E-mail id")
            isFieldsValid = false
        } else {
            if (!isValidEmail(email: email)) {
                showAlert(message: "Please add valid E-mail id")
                isFieldsValid = false
            }
        }
        
        if (password == nil || password == "") {
            showAlert(message: "Please add password")
            isFieldsValid = false
        } else {
            if (!isValidPassword(password: password)) {
                isFieldsValid = false
                showAlert(message: "Password should have minimum one upper case, one lower case, one digit and minimum 6 digit characters.")
            }
        }
        return isFieldsValid
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
      
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        if (isLoginFieldValid(email: email, password: password)) {
            if Connectivity.isConnectedToInternet {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if (error == nil && user != nil) {
                        
                        let device = ["device":["id":Constants.device.id ?? "",
                                                "model":Constants.device.type,
                                                "os_version":Constants.device.osVersion,
                                                "token":Constants.device.token]]
                        
                        
                        Constants.db.collection("admin").document("1").setData(["account_info":device], merge: true)
                        
                        PreferenceManager.setUserLogin(isUserLogin: true)
                        
                        self.dismiss(animated: true, completion: nil)

                    } else {
                        PreferenceManager.setUserLogin(isUserLogin: false)
                        let errorMsg = (error?.localizedDescription ?? "Username or Password is invalid!")
                        self.showAlert(errorMsg)
                        print("Error Logged In : \(errorMsg) ")
                    }
                }
            } else {
                showAlert(message: "Please check your internet connection!")
            }
        }
    }
}
