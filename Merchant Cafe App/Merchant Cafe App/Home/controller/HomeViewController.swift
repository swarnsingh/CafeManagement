/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import SideMenuSwift
import Toast_Swift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orderArray = [OrderDetail]()
    
    @IBOutlet var OrderTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        
        if !PreferenceManager.isUserLogin() {
            self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
        }
        
    }
 
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
                    self.showAlert("User logged in from another device. Please login again.")
                    PreferenceManager.setUserLogin(isUserLogin: false)
                    self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
                    
                }
            }
            print("Account Info : \(String(describing: account_info["device_id"]))")
        }
    }
    
    private func goToController(controller: String, nextViewController : AnyClass) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: controller)
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func sidmenuButtonPressed(_ sender:UIButton){
        
        self.sideMenuController?.revealMenu()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        if Connectivity.isConnectedToInternet {
            self.getOrders()
        } else {
            self.view.makeToast("Please check your internet connection!", duration: 1.0, position: .bottom)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return orderArray.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let order = orderArray[indexPath.section]
        
        let OrderId = cell?.viewWithTag(101) as! UILabel
        let OrderPrice = cell?.viewWithTag(102) as! UILabel
        let OrderItems = cell?.viewWithTag(103) as! UILabel
        let OrderPlacedAt = cell?.viewWithTag(104) as! UILabel
        let OrderPlacedBy = cell?.viewWithTag(105) as! UILabel
        
        OrderId.text = order.orderId
        OrderPrice.text = "\(order.orderPrice)"
        OrderItems.text = "\(order.products.count)"
        
        
        
        if order.states.keys.contains(OrderDetail.OrderStatus.Placed){
            
            let placedAt = order.states[.Placed]
            Constants.dateFormatter.dateFormat = "dd MMM yyyy"
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)

        }
        
        
        
        OrderPlacedBy.text = order.user.firstName

        cell?.selectionStyle = .none
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = orderArray[indexPath.section]
        
       
           /* let orderDetailVC = /AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.PRODUCT_VIEW_SEGUE) as! ProductViewController
            
           // orderDetailV = category
            orderDetailVC.orderArray = orderArray
            
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
       
       */
    }
    
    
    
    func getOrders() {
        
        Firestore.firestore().collection("order").addSnapshotListener{ (snapshot, error) in
            
            if error == nil {
                
                self.orderArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let order = OrderDetail(info: document.data(), id: document.documentID )
                    
                    self.orderArray.append(order)
                    
                }
                self.OrderTableView.reloadData()
                
            }
            
        }
        
    }
    
    
}

