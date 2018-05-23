/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var forgotPasswordLabel:UILabel!
    
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
        return (password?.count)! >= 6;
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
                showAlert(message: "Password length must be 6 digits.")
            }
        }
        return isFieldsValid
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      
        if (isLoginFieldValid(email: email, password: password)) {
            if Connectivity.isConnectedToInternet {
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    if (error == nil && user != nil) {
                        
                        let deviceID = UIDevice.current.identifierForVendor?.uuidString
                        
                        Constants.db.collection("Admin").document("1").setData(["account_info":["device_id":deviceID!]], merge: true)
                        
                        PreferenceManager.setUserLogin(isUserLogin: true)
                        self.performSegue(withIdentifier: Constants.HOME_SEGUE, sender: nil)
                        print("User Device ID : \(String(describing: deviceID))")
                        print("Login successfully : \(String(describing: user?.user.email))")
                    } else {
                        PreferenceManager.setUserLogin(isUserLogin: false)
                        print("Error Logged In : \(String(describing: error?.localizedDescription)) ")
                    }
                }
            } else {
                showAlert(message: "Please check your internet connection!")
            }
        }
    }
}
