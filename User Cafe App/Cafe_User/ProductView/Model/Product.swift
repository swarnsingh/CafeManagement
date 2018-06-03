//
//  Product.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation


struct Product {
    
    var name = ""
    var image = ""
    var images = [String]()
    var detail = ""
    var id = ""
    var price = 0.0
    
    init(info:[String:Any],id:String) {
        
        self.name = info["name"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.id = id
        self.price = info["price"] as? Double ?? 0.0
        self.detail = info["detail"] as? String ?? ""
        
        if info.keys.contains("images"){
            
            self.images = info["images"] as? [String] ?? []
            
        }
        
    }
    
}
