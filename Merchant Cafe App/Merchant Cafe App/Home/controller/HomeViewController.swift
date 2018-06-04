/**
 *  @author Swarn Singh.
 */

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var productsBtn: UIButton!
    
    @IBOutlet var Categorybtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        if !PreferenceManager.isUserLogin() {
            self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet {
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
                        self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
                        self.showAlert("User logged in from another device. Please login again.")
                    }
                }
                print("Account Info : \(String(describing: account_info["device_id"]))")
            }
        }
    }
    
    private func goToController(controller: String, nextViewController : AnyClass) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: controller)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func onProductClick(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.CATEGORY_PRODUCT_SEGUE, sender: nil)
    }
    
    @IBAction func onCategoryPress(_ sender: UIButton){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryProductViewController") as! CategoryProductViewController
        nextViewController.isFromCategory = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PreferenceManager.setUserLogin(isUserLogin: false)
        self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Categorybtn.layer.cornerRadius = 10
        self.navigationController?.navigationBar.tintColor = .white
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
