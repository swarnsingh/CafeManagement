/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import Firebase
import MBProgressHUD
import Toast_Swift

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var orderNoLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var orderFromLabel: UILabel!
    
    @IBOutlet weak var acceptOrderBtn: CustomButton!
    
    @IBOutlet weak var declineOrderBtn: CustomButton!
    
    var orderDetail: OrderDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if orderDetail != nil {
            self.priceLabel.text = String(format:"%.1f", (orderDetail?.orderPrice)!)
            self.quantityLabel.text = "\(orderDetail?.products.count ?? 0) Items"
            
            Constants.dateFormatter.dateFormat = "dd MMM yyyy"
            self.orderDateLabel.text = Constants.dateFormatter.string(from: (orderDetail?.states[.Placed])!)
            self.orderNoLabel.text = "Order No. #\(orderDetail?.orderId ?? "0")"
            
            orderFromLabel.text = "Order From: \(orderDetail?.user.firstName ?? "")"
            
            if ((orderDetail?.states[.Ready]) != nil) {
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.delieveredButtonPressed), for: .touchUpInside)
                acceptOrderBtn.setTitle("Ready",for: .normal)
                acceptOrderBtn.isEnabled = false
                acceptOrderBtn.alpha = 0.5
                declineOrderBtn.setTitle("Delivered",for: .normal)
            } else if ((orderDetail?.states[.Accepted]) != nil) {
                acceptOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.readyButtonPressed), for: .touchUpInside)
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.delieveredButtonPressed), for: .touchUpInside)
                acceptOrderBtn.setTitle("Ready",for: .normal)
                declineOrderBtn.setTitle("Delivered",for: .normal)
            } else if ((orderDetail?.states[.Placed]) != nil) {
                acceptOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.acceptButtonPressed), for: .touchUpInside)
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.declineButtonPressed), for: .touchUpInside)
            }
        }
    }
    
    @objc func readyButtonPressed() {
        if Connectivity.isConnectedToInternet {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            print("Ready Order")
            
            let document = Firestore.firestore().collection("order").document(orderDetail!.documentID)
            
            document.setData(["status":[OrderDetail.OrderStatus.Ready.rawValue:FieldValue.serverTimestamp()]], merge: true)
            
            MBProgressHUD.hide(for: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
            self.view.makeToast("Order Ready message sent Succesfully", duration: 1.0, position: .bottom)
            
        } else {
            self.view.makeToast("Please check internet connection!", duration: 1.0, position: .bottom)
            
        }
    }
    
    @objc func delieveredButtonPressed() {
        print("Delivered")
        self.showAlertController(.alert, title: "Deliver Order", text: "Press confirm to deliver the order", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0{
                
            }
        }
    }
    
    @objc func acceptButtonPressed() {
        
        self.showAlertController(.alert, title: "Accept Order", text: "Press confirm to accept the order", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0{
                
                
                if Connectivity.isConnectedToInternet {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    print("Accept Order")
                    
                    let document = Firestore.firestore().collection("order").document(self.orderDetail!.documentID)
                    
                    document.setData(["status":[OrderDetail.OrderStatus.Accepted.rawValue:FieldValue.serverTimestamp()]], merge: true)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    self.view.makeToast("Order Accepted Succesfully", duration: 1.0, position: .bottom)
                } else {
                    self.view.makeToast("Please check internet connection!", duration: 1.0, position: .bottom)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func declineButtonPressed() {
        
        self.showAlertController(.alert, title: "Decline Order", text: "Press confirm to decline the order", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0{
                if Connectivity.isConnectedToInternet {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    print("Decline Order")
                    
                    let document = Firestore.firestore().collection("order").document(self.orderDetail!.documentID)
                    
                    document.setData(["status":[OrderDetail.OrderStatus.Declined.rawValue:FieldValue.serverTimestamp()]], merge: true)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.view.makeToast("Order Declined Succesfully", duration: 1.0, position: .bottom)
                } else {
                    
                    self.view.makeToast("Please check internet connection!", duration: 1.0, position: .bottom)
                    
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
