/**
 *  @author Swarn Singh.
 */

import Foundation
import UIKit

struct OrderDetail {
    
    enum OrderStatus:String {
        case Placed,Accepted,Declined,Ready,Delivered
    }
    
    var orderId = ""
    var otp = ""
    var documentID = ""
    var instruction = ""
    var orderPrice = 0.0
    var products = [Product]()
    var states = [OrderStatus:Date]()
    var user: User
    
    init(info:[String:Any], id:String) {
        self.instruction = info["instruction"] as? String ?? ""
        self.orderPrice =  info["order_price"] as? Double ?? 0.0
        self.orderId = info["order_id"] as? String ?? ""
        self.documentID = id
        self.otp = info["otp"] as? String ?? ""
        
        let userJSON = info["user_info"] as? [String:Any] ?? [:]
        
        self.user = User.init(info: userJSON)
        
        let productJSON = info["products"] as? [[String:Any]] ?? [[:]]
        
        for product in productJSON {
            self.products.append(Product(info: product))
        }
        
        let statusJSON = info["status"] as? [String:Any] ?? [:]
        
        for (key,value) in statusJSON{
            
            Constants.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            
            guard let date = Constants.dateFormatter.date(from: String(describing: value)) else {return}
            
            states[OrderStatus(rawValue: key)!] = date

        }
        
    }
    
    struct Product {
        var id = ""
        var image = ""
        var name = ""
        var price = 0.0
        var quantity = 0
        
        init(info:[String:Any]) {
            self.id = info["id"] as? String ?? ""
            self.image = info["image"] as? String ?? ""
            self.name = info["name"] as? String ?? ""
            self.price = info["price"] as? Double ?? 0.0
            self.quantity = info["quantity"] as? Int ?? 0
        }
    }
    
    struct User {
        var firstName = ""
        var lastName = ""
        var id = ""
        var profileImage = ""
        
        init(info:[String:Any]) {
            self.firstName = info["first_name"] as? String ?? ""
            self.lastName = info["last_name"] as? String ?? ""
            self.id = info["id"] as? String ?? ""
            self.profileImage = info["profile_image"] as? String ?? ""
        }
    }
    
}
