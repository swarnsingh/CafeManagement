//
//  Category.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation

struct Category {
    
    var id = ""
    var name = ""
    var products = [String]()
    var image = ""
    
    init(info:[String:Any],id:String) {
        
        self.name = info["name"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.id = id
        self.products = info["products"] as? [String] ?? []
        
    }
    
}
