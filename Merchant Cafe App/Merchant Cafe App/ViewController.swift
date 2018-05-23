/**
 *  @author Swarn Singh.
 */

import UIKit

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            
            if PreferenceManager.isUserLogin() {
                self.performSegue(withIdentifier: Constants.HOME_SEGUE, sender: nil)
            } else {
                self.performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: nil)
            }
            
        }
        
        Constants.db.collection("Admin").document("1").addSnapshotListener(
        includeMetadataChanges: true) { querySnapshot, error in
            guard let documents = querySnapshot?.get("account_info") else {
                print("Error fetching account_info documents: \(error!)")
                return
            }
            let account_info: [String:Any] = documents as! [String : Any]
            
            let deviceId = account_info["device_id"] as! String
            
            if deviceId != UIDevice.current.identifierForVendor?.uuidString {
                PreferenceManager.setUserLogin(isUserLogin: false)
                self.performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: nil)
            }
            print("Account Info : \(String(describing: account_info["device_id"]))")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

