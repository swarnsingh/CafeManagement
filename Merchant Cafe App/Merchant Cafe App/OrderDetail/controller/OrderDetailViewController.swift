/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import Firebase
import MBProgressHUD
import Toast_Swift

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    @IBOutlet weak var orderNoLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var orderTableView: UITableView!
    
    @IBOutlet weak var orderFromLabel: UILabel!
    
    @IBOutlet weak var acceptOrderBtn: CustomButton!
    
    @IBOutlet weak var declineOrderBtn: CustomButton!
    
    @IBOutlet weak var userMobileText: UILabel!
    
    var orderDetail: OrderDetail?
    
    var otp: String?
    
    var orderStatusObserver:ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if orderDetail != nil {
            self.priceLabel.text = String(format:"%.1f", (orderDetail?.orderPrice)!)
            self.quantityLabel.text = "\(orderDetail?.products.count ?? 0) Items"
            if orderDetail?.user.mobile != "" {
                self.userMobileText.text = "Contact : \(orderDetail?.user.mobile ?? "")"
            }
            
            Constants.dateFormatter.dateFormat = "dd MMM yyyy"
            self.orderDateLabel.text = Constants.dateFormatter.string(from: (orderDetail?.states[.Placed])!)
            self.orderNoLabel.text = "Order No. #\(orderDetail?.orderId ?? "0")"
            
            orderFromLabel.text = "Order By: \(orderDetail?.user.firstName ?? "")"
            
            if ((orderDetail?.states[.Cancelled]) != nil) {
                acceptOrderBtn.isHidden = true
                declineOrderBtn.isHidden = true
                orderStatusLabel.textColor = UIColor.lightGray
                orderStatusLabel.text = OrderDetail.OrderStatus.Cancelled.rawValue
            } else if ((orderDetail?.states[.Delivered]) != nil) {
                acceptOrderBtn.isHidden = true
                declineOrderBtn.isHidden = true
                orderStatusLabel.textColor = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
                orderStatusLabel.text = OrderDetail.OrderStatus.Delivered.rawValue
            } else if ((orderDetail?.states[.Declined]) != nil) {
                acceptOrderBtn.isHidden = true
                declineOrderBtn.isHidden = true
                orderStatusLabel.text = OrderDetail.OrderStatus.Declined.rawValue
                orderStatusLabel.textColor = UIColor.red
            } else if ((orderDetail?.states[.Ready]) != nil) {
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.delieveredButtonPressed), for: .touchUpInside)
                acceptOrderBtn.setTitle("Ready",for: .normal)
                acceptOrderBtn.isEnabled = false
                acceptOrderBtn.alpha = 0.5
                declineOrderBtn.setTitle("Pick Up",for: .normal)
                orderStatusLabel.text = OrderDetail.OrderStatus.Ready.rawValue
            } else if ((orderDetail?.states[.Accepted]) != nil) {
                acceptOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.readyButtonPressed), for: .touchUpInside)
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.delieveredButtonPressed), for: .touchUpInside)
                acceptOrderBtn.setTitle("Ready",for: .normal)
                declineOrderBtn.setTitle("Pick Up",for: .normal)
                orderStatusLabel.text = OrderDetail.OrderStatus.Accepted.rawValue
            } else if ((orderDetail?.states[.Placed]) != nil) {
                acceptOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.acceptButtonPressed), for: .touchUpInside)
                declineOrderBtn.addTarget(self, action: #selector(OrderDetailViewController.declineButtonPressed), for: .touchUpInside)
                orderStatusLabel.text = OrderDetail.OrderStatus.Placed.rawValue
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(OrderDetailViewController.tapFunction))
            userMobileText.isUserInteractionEnabled = true
            userMobileText.addGestureRecognizer(tap)
            
            observeOrderStatus()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let orderObserver = orderStatusObserver else {return}
        
        orderObserver.remove()
        
    }
    
    private func observeOrderStatus() {
        
        if orderDetail?.states.count == 1 {
            
            orderStatusObserver = Firestore.firestore().collection(Database.Collection.order.rawValue).document(orderDetail!.orderId).addSnapshotListener { (snapshot, error) in
                
                if error == nil && (snapshot?.exists)! {
                    
                    let order = OrderDetail(info: snapshot!.data()!, id: snapshot!.documentID)
                    
                    if order.states[.Cancelled] != nil {
                        self.showAlert("This order has been cancelled by \(order.user.firstName)", callback: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        
        let phone = orderDetail?.user.mobile
        
        let url = URL(string: "tel://\(phone ?? "")")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            self.showAlert("Device unable to make calls.")
        }
    }
    
    @objc func readyButtonPressed() {
        if Connectivity.isConnectedToInternet {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let document = Firestore.firestore().collection(Database.Collection.order.rawValue).document(orderDetail!.documentID)
            
            document.setData(["status":[OrderDetail.OrderStatus.Ready.rawValue:FieldValue.serverTimestamp()]], merge: true)
            
            MBProgressHUD.hide(for: self.view, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                _ = self.navigationController?.popViewController(animated: true)
            })
            self.view.makeToast(SuccessMessage.orderReady.stringValue, duration: 1.0, position: .bottom)
            
        } else {
            self.view.makeToast(ErrorMessage.internetConnection.stringValue, duration: 1.0, position: .bottom)
        }
    }
    
    @objc func delieveredButtonPressed() {
        showInputDialog()
    }
    
    func showInputDialog() {
        
        let alertController = UIAlertController(title: "Validate Order!", message: "Please Enter The OTP", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            self.otp = alertController.textFields?[0].text
            
            if self.otp ==  self.orderDetail?.otp {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let document = Firestore.firestore().collection(Database.Collection.order.rawValue).document(self.orderDetail!.documentID)
                
                document.setData(["status":[OrderDetail.OrderStatus.Delivered.rawValue:FieldValue.serverTimestamp()]], merge: true)
                MBProgressHUD.hide(for: self.view, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                    _ = self.navigationController?.popViewController(animated: true)
                })
                self.view.makeToast(SuccessMessage.orderPicked.stringValue, duration: 1.0, position: .bottom)
            }
            else {
                self.showAlert("OTP Doesn't Match!")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter OTP"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func acceptButtonPressed() {
        
        self.showAlertController(.alert, title: "Accept Order", text: "Press confirm to accept the order", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0 {
                
                if Connectivity.isConnectedToInternet {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    let document = Firestore.firestore().collection(Database.Collection.order.rawValue).document(self.orderDetail!.documentID)
                    
                    document.setData(["status":[OrderDetail.OrderStatus.Accepted.rawValue:FieldValue.serverTimestamp()]], merge: true)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    self.view.makeToast(SuccessMessage.orderAccepted.stringValue, duration: 1.0, position: .bottom)
                } else {
                    self.view.makeToast(ErrorMessage.internetConnection.stringValue, duration: 1.0, position: .bottom)
                }
            }
        }
    }
    
    @objc func declineButtonPressed() {
        
        self.showAlertController(.alert, title: "Decline Order", text: "Press confirm to decline the order", options: ["Confirm"]) { (tappedIndex) in
            
            if tappedIndex == 0 {
                if Connectivity.isConnectedToInternet {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    let document = Firestore.firestore().collection(Database.Collection.order.rawValue).document(self.orderDetail!.documentID)
                    
                    document.setData(["status":[OrderDetail.OrderStatus.Declined.rawValue:FieldValue.serverTimestamp()]], merge: true)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.view.makeToast(ErrorMessage.orderDeclined.stringValue, duration: 1.0, position: .bottom)
                } else {
                    self.view.makeToast(ErrorMessage.internetConnection.stringValue, duration: 1.0, position: .bottom)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
