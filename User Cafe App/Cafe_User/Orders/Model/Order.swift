//
//  Order.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 07/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation

struct Order {
    
    enum Status:String {
        case Placed,Accepted,Declined,Ready,Delivered
        
        var sequence:Int{
            
            switch self {
            case .Placed:
                return 1
            case .Accepted:
                return 2
            case .Declined:
                return 3
            case .Ready:
                return 4
            case .Delivered:
                return 5
            }
            
        }
        
    }
    
    var id = ""
    var instructions = ""
    var price = 0.0
    var products = [Product]()
    var buyer:User!
    var statusInfo = [String:Any]()
    
    init(info:[String:Any]) {
        
        self.id = info["order_id"] as? String ?? ""
        self.price = info["order_price"] as? Double ?? 0.0
        
        for productInfo in info["products"] as? [[String:Any]] ?? [[:]]{
            
            products.append(Product(info: productInfo))
            
        }
        
        buyer = User(info: info["user_info"] as? [String:Any] ?? [:])
        
        statusInfo = info["status"] as? [String:Any] ?? [:]

    }
}

extension Order{
    
    var status:Status{
        
        var statusArray = [Status]()
        
        for state in statusInfo.keys{
            statusArray.append(Status(rawValue: state)!)
        }
        
        let maxSequence = statusArray.map{$0.sequence}.max() ?? 0
        
        return statusArray.filter{$0.sequence == maxSequence}.first!
        
    }
    
    var placedAt:String{
        
        let dateString = statusInfo[Status.Placed.rawValue] as? String ?? ""
        
        Constants.dateFormatter.dateFormat = "yyyy-MM-dd HH:ss:mm +ZZZ"
        
        let date = Constants.dateFormatter.date(from: dateString) ?? Date()
        
        Constants.dateFormatter.dateFormat = nil
        Constants.dateFormatter.dateStyle = .short
        Constants.dateFormatter.timeStyle = .short
        
        return Constants.dateFormatter.string(from: date)
        
    }
    
    var deliveredAt:String{
        
        let dateString = statusInfo[Status.Delivered.rawValue] as? String ?? ""
        
        Constants.dateFormatter.dateFormat = "yyyy-MM-dd HH:ss:mm +ZZZ"
        
        let date = Constants.dateFormatter.date(from: dateString) ?? Date()
        
        Constants.dateFormatter.dateFormat = nil
        Constants.dateFormatter.dateStyle = .medium
        Constants.dateFormatter.timeStyle = .medium
        
        return Constants.dateFormatter.string(from: date)
        
    }
    
}
