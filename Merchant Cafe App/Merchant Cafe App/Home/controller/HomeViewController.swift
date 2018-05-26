/**
 *  @author Swarn Singh.
 */

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var logOutBtn: CustomButton!
    
    override func viewDidAppear(_ animated: Bool) {
        Constants.db.collection("Admin").document("1").addSnapshotListener(
        includeMetadataChanges: true) { querySnapshot, error in
            guard let documents = querySnapshot?.get("account_info") else {
                print("Error fetching account_info documents: \(error!)")
                return
            }
            let account_info: [String:Any] = documents as! [String : Any]
            
            let deviceId = account_info["device_id"] as! String
            
            if deviceId != UIDevice.current.identifierForVendor?.uuidString {
                if (PreferenceManager.isUserLogin()) {
                    PreferenceManager.setUserLogin(isUserLogin: false)
                    self.showAlert("User logged in from another device. Please login again.")
                    self.performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: nil)
                }
            }
            print("Account Info : \(String(describing: account_info["device_id"]))")
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PreferenceManager.setUserLogin(isUserLogin: false)
        self.performSegue(withIdentifier: Constants.LOGIN_SEGUE, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
