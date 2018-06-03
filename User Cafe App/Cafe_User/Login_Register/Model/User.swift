//
//  User.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct User:Codable {
    
    static var current = User()
    
    struct Device {
        
        var id = ""
        var type = ""
        var token = ""
        var osVersion = 0.0
    }
    
    enum State{
        case loggedIn,loggedOut
    }
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var device = Device()
    var id = ""
    var state = State.loggedOut
    
    enum CodingKeys: String, CodingKey{
        
        case firstName
        case lastName
        case email
        case id
    
    }
    
    private init(){
        
        if UserDefaults.standard.object(forKey: "CafeUser") != nil{
            
            let data = UserDefaults.standard.object(forKey: "CafeUser") as! Data
            
            self = try! JSONDecoder().decode(User.self, from: data)
            
            self.state = .loggedIn

        }
        
    }

}

extension User{
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(id, forKey: .id)

    }
    
}

extension User{
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        email = try values.decode(String.self, forKey: .email)
        id = try values.decode(String.self, forKey: .id)

    }
    
}

extension User{
    
    mutating func logout(){
        
        self.state = .loggedOut
        UserDefaults.standard.removeObject(forKey: "CafeUser")
        
    }
    
    mutating func update(info:[String:Any], id:String){
        
        self.firstName = info["first_name"] as? String ?? ""
        self.lastName = info["last_name"] as? String ?? ""
        self.email = info["email"] as? String ?? ""
        self.id = id
        self.state = .loggedIn
        
    }
    
}
