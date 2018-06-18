/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import MBProgressHUD
import Toast_Swift

class MerchantReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var merchantReportTableView: UITableView!
    private var orderArray = [OrderDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Order Reports"
        self.navigationItem.backBarButtonItem?.title = ""
        if Connectivity.isConnectedToInternet {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            getReports()
            MBProgressHUD.hide(for: self.view, animated: true)
        } else {
            self.view.makeToast("Please check internet connection!", duration: 1.0, position: .center)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let order = orderArray[indexPath.row]
        
        let orderId = cell?.viewWithTag(101) as! UILabel
        let orderPrice = cell?.viewWithTag(102) as! UILabel
        let OrderPlacedAt = cell?.viewWithTag(104) as! UILabel
        let orderPlacedBy = cell?.viewWithTag(105) as! UILabel
        let orderStatus = cell?.viewWithTag(106) as! UILabel
        
        orderId.text = "#\(order.orderId)"
        orderPrice.text = "₹\(order.orderPrice)"
        
        if order.states.keys.contains(OrderDetail.OrderStatus.Delivered) {
            orderStatus.text = "Delivered"
            
            orderStatus.textColor = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
            
            let placedAt = order.states[.Delivered]
            Constants.dateFormatter.dateFormat = "dd MMM yy h:mm a"
            
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
        } else {
            orderStatus.text = "Declined"
            
            orderStatus.textColor = UIColor.red
            
            let placedAt = order.states[.Declined]
            Constants.dateFormatter.dateFormat = "dd MMM yy h:mm a"
            
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
        }
        
        orderPlacedBy.text = "\(order.user.firstName) \(order.user.lastName)"
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = orderArray[indexPath.row]
        
        let orderDetailVC = AppStoryBoard.OrderDetail.instance.instantiateViewController(withIdentifier: Constants.ORDER_DETAIL_VIEW_SEGUE) as! OrderDetailViewController
        
        orderDetailVC.orderDetail = order
        
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    private func getReports() {
        Firestore.firestore().collection("order").order(by: "status", descending: true).addSnapshotListener{ (snapshot, error) in
            
            if error == nil {
                
                self.orderArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let order = OrderDetail(info: document.data(), id: document.documentID)
                    
                    if order.states.keys.contains(OrderDetail.OrderStatus.Delivered) || order.states.keys.contains(OrderDetail.OrderStatus.Declined) {
                        self.orderArray.append(order)
                    }
                }
                
                self.orderArray = self.orderArray.sorted(by: { (order1, order2) -> Bool in
                    
                    let orderPlaced1Date = order1.states[.Delivered] != nil ? order1.states[.Delivered] : order1.states[.Declined]
                    let orderPlaced2Date = order2.states[.Delivered] != nil ? order2.states[.Delivered] : order2.states[.Declined]
                    
                    guard let date1 = orderPlaced1Date, let date2 = orderPlaced2Date else {return false}
                    
                    return date1.compare(date2) == .orderedDescending
                    
                })
                
                self.merchantReportTableView.reloadData()
            }
        }
    }
}
