/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import SideMenuSwift
import Toast_Swift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var totalOrders: UILabel!
    @IBOutlet var TotalSales: UILabel!
    @IBOutlet var OrderTableView: UITableView!
    var orderArray = [OrderDetail]()
    var deliveredOrderArray = [OrderDetail]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !PreferenceManager.isUserLogin() {
            self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
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
        
        totalOrders.backgroundColor  = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
        TotalSales.backgroundColor  = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
        
        if Connectivity.isConnectedToInternet {
            self.getOrders()
            
        } else {
            self.view.makeToast("Please check your internet connection!", duration: 1.0, position: .bottom)
        }
        
        Constants.db.collection("admin").document("1").addSnapshotListener(
        includeMetadataChanges: true) { querySnapshot, error in
            
            let accountData = querySnapshot?.data()!["account_info"] as? [String:Any] ?? [:]
            
            let deviceData = accountData["device"] as? [String:Any] ?? [:]
            
            let deviceId = deviceData["id"] as? String ?? ""
            
            if deviceId != UIDevice.current.identifierForVendor?.uuidString {
                if (PreferenceManager.isUserLogin()) {
                    self.showAlert("User logged in from another device. Please login again.")
                    PreferenceManager.setUserLogin(isUserLogin: false)
                    self.goToController(controller: Constants.LOGIN_SEGUE, nextViewController: LoginViewController.self)
                    
                }
            }
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let order = orderArray[indexPath.row]
        
        let OrderId = cell?.viewWithTag(101) as! UILabel
        let OrderPrice = cell?.viewWithTag(102) as! UILabel
        //let OrderItems = cell?.viewWithTag(103) as! UILabel
        let OrderPlacedAt = cell?.viewWithTag(104) as! UILabel
        let OrderPlacedBy = cell?.viewWithTag(105) as! UILabel
        let OrderStatus = cell?.viewWithTag(106) as! UILabel
        
        OrderId.text = "#\(order.orderId)"
        OrderPrice.text = "₹\(order.orderPrice)"
        // OrderItems.text = "\(order.products.count)"
        
        
        
        if order.states.keys.contains(OrderDetail.OrderStatus.Placed){
            
            let placedAt = order.states[.Placed]
            Constants.dateFormatter.dateFormat = nil
            Constants.dateFormatter.dateStyle = .short
            Constants.dateFormatter.timeStyle = .short
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
            
        }
        
        if order.states.keys.contains(OrderDetail.OrderStatus.Ready){
            OrderStatus.text = "Ready"
            
            OrderStatus.textColor = UIColor.init(red: 51/255.0, green: 102/255.0, blue: 255/255.0, alpha: 1.0)
            
        } else if  order.states.keys.contains(OrderDetail.OrderStatus.Accepted){
            OrderStatus.text = "Accepted"
            
            OrderStatus.textColor = UIColor.init(red: 51/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1.0)
        } else {
            OrderStatus.text = "Placed"
            
            OrderStatus.textColor = UIColor.init(red: 255/255.0, green: 163/255.0, blue: 26/255.0, alpha: 1.0)
        }
        
        OrderPlacedBy.text = "\(order.user.firstName) \(order.user.lastName)"
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = orderArray[indexPath.row]
        
        let orderDetailVC = AppStoryBoard.OrderDetail.instance.instantiateViewController(withIdentifier: Constants.ORDER_DETAIL_VIEW_SEGUE) as! OrderDetailViewController
        
        orderDetailVC.orderDetail = order
        
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
        
    }
    
    
    func getOrders() {
        
        Firestore.firestore().collection("order").order(by: "status", descending: true).addSnapshotListener{ (snapshot, error) in
            
            if error == nil {
                
                self.orderArray.removeAll()
                self.deliveredOrderArray.removeAll()
                for document in (snapshot?.documents)!{
                    
                    let order = OrderDetail(info: document.data(), id: document.documentID)
                    
                    self.orderArray.append(order)
                    
                }
                
                self.deliveredOrderArray = self.orderArray.filter{
                    
                    if $0.states.keys.contains(.Delivered){
                        
                        guard let deliveredAt = $0.states[.Delivered] else {return false}
                        
                        let dayOfDelivery = Calendar.current.component(.day, from: deliveredAt)
                        
                        let currentDay = Calendar.current.component(.day, from: Date())
                        
                        return currentDay-dayOfDelivery < 30
                        
                    }
                    
                    return false
                }
                
                
                let totalDeliveredPrice = self.deliveredOrderArray.map{$0.orderPrice}.reduce(0.0,+)
                print(totalDeliveredPrice)
                self.totalOrders.text = "Total Orders: \n \(self.deliveredOrderArray.count)"
                self.TotalSales.text = "Total Sales: \n ₹\(totalDeliveredPrice)"
                self.orderArray = self.orderArray.filter{ return !$0.states.keys.contains(.Delivered) && !$0.states.keys.contains(.Declined) }
                
                self.orderArray = self.orderArray.sorted(by: { (order1, order2) -> Bool in
                    
                    let orderPlaced1Date = order1.states[.Placed]
                    let orderPlaced2Date = order2.states[.Placed]
                    
                    guard let date1 = orderPlaced1Date, let date2 = orderPlaced2Date else {return false}
                    
                    return date1.compare(date2) == .orderedDescending
                    
                })
                
                self.OrderTableView.reloadData()
            }
        }
    }
}

