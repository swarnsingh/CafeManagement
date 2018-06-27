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
        self.navigationItem.title = "Order History"
        self.navigationItem.backBarButtonItem?.title = ""
        if Connectivity.isConnectedToInternet {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            getReports()
            MBProgressHUD.hide(for: self.view, animated: true)
        } else {
            self.view.makeToast(ErrorMessage.internetConnection.stringValue, duration: 1.0, position: .center)
        }
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
        
        let orderId = cell?.viewWithTag(101) as! UILabel
        let orderPrice = cell?.viewWithTag(102) as! UILabel
        let OrderPlacedAt = cell?.viewWithTag(104) as! UILabel
        let orderPlacedBy = cell?.viewWithTag(105) as! UILabel
        let orderStatus = cell?.viewWithTag(106) as! UILabel
        let userProfile = cell?.viewWithTag(107) as! UIImageView
        
        let url = URL(string:order.user.profileImage)
        let placeholderImage = UIImage(named: "images.jpeg")!
        if url != nil {
            userProfile.af_setImage(withURL: url!, placeholderImage: placeholderImage)
        } else {
            userProfile.image = placeholderImage
        }
        
        orderId.text = "#\(order.orderId)"
        orderPrice.text = "\(Constants.config.currency)\(order.orderPrice)"
        
        Constants.dateFormatter.dateFormat = "dd MMM yy h:mm a"
        
        if order.states.keys.contains(OrderDetail.OrderStatus.Delivered) {
            orderStatus.text = OrderDetail.OrderStatus.Delivered.rawValue
            
            orderStatus.textColor = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
            
            let placedAt = order.states[.Delivered]
            
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
        } else if order.states.keys.contains(OrderDetail.OrderStatus.Cancelled) {
            orderStatus.text = OrderDetail.OrderStatus.Cancelled.rawValue
            
            orderStatus.textColor = UIColor.lightGray
            
            let placedAt = order.states[.Cancelled]
            
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
        } else {
            orderStatus.text = OrderDetail.OrderStatus.Declined.rawValue
            
            orderStatus.textColor = UIColor.red
            
            let placedAt = order.states[.Declined]
            
            OrderPlacedAt.text = Constants.dateFormatter.string(from: placedAt!)
        }
        
        orderPlacedBy.text = "\(order.user.firstName) \(order.user.lastName)"
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = orderArray[indexPath.section]
        
        let orderDetailVC = AppStoryBoard.OrderDetail.instance.instantiateViewController(withIdentifier: Constants.ORDER_DETAIL_VIEW_SEGUE) as! OrderDetailViewController
        
        orderDetailVC.orderDetail = order
        
        self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    private func getReports() {
        Firestore.firestore().collection(Database.Collection.order.rawValue).order(by: "status", descending: true).addSnapshotListener{ (snapshot, error) in
            
            if error == nil {
                
                self.orderArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let order = OrderDetail(info: document.data(), id: document.documentID)
                    
                    if order.states.keys.contains(OrderDetail.OrderStatus.Delivered) || order.states.keys.contains(OrderDetail.OrderStatus.Declined) || order.states.keys.contains(OrderDetail.OrderStatus.Cancelled) {
                        self.orderArray.append(order)
                    }
                }
                
                self.orderArray = self.orderArray.sorted(by: { (order1, order2) -> Bool in
                    
                    let orderPlaced1Date = order1.states[.Placed]
                    let orderPlaced2Date = order2.states[.Placed]
                    
                    guard let date1 = orderPlaced1Date, let date2 = orderPlaced2Date else {return false}
                    
                    return date1.compare(date2) == .orderedDescending
                    
                })
                
                self.merchantReportTableView.reloadData()
            }
        }
    }
}
