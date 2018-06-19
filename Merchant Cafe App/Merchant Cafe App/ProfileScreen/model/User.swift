//
//  User.swift
//  Cafe_User
//
//  Created by Umang Gupta on 14/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct User:Codable {
    
    static var current = User()
    
    enum State{
        case loggedIn,loggedOut
    }
    
    var firstName = ""
    var lastName = ""
    var image = ""
    var email = ""
    var id = ""
    var state = State.loggedOut
    
    enum CodingKeys: String, CodingKey{
        
        case firstName
        case lastName
        case email
        case image
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
        try container.encode(image, forKey: .image)

    }
    
}

extension User{
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        email = try values.decode(String.self, forKey: .email)
        image = try values.decode(String.self, forKey: .image)
        id = try values.decode(String.self, forKey: .id)

    }
    
}

extension User{
    
    var jsonRepresentation:[String:String]{
        
        return ["id":id,
                "first_name":firstName,
                "last_name":lastName,
                "image":image]
    }
    
    func updateDeviceInfo(){
        
        let device = ["device":["id":Constants.device.id ?? "",
                                "model":Constants.device.type,
                                "os_version":Constants.device.osVersion,
                                "token":Constants.device.token]]
        
        let database = Firestore.firestore().collection(Database.Collection.user.rawValue).document(self.id)
        
        database.setData(device, merge: true)
        
    }
    
    mutating func logout(){
        
        self.state = .loggedOut
        UserDefaults.standard.removeObject(forKey: "CafeUser")
        try? Auth.auth().signOut()
        
    }
    
    init(info:[String:Any]) {
        
        firstName = info["first_name"] as? String ?? ""
        lastName = info["last_name"] as? String ?? ""
        image = info["image"] as? String ?? ""
        id = info["id"] as? String ?? ""

    }
    
    mutating func syncWithFirebase(completionHandler:@escaping ()->Void){
        
        Database.getDataOf(.admin, At: "1", callback: { data in
            
            guard var userInfo = data else { return }
            
            userInfo["email"] = User.current.email
            
            User.current.update(info: userInfo, id: User.current.id)
            
            let userData = try! JSONEncoder().encode(User.current)
            
            UserDefaults.standard.set(userData, forKey: "CafeUser")
            
            completionHandler()
            
        })
        
    }
    
    mutating func update(info:[String:Any], id:String){
        
        self.firstName = info["first_name"] as? String ?? ""
        self.lastName = info["last_name"] as? String ?? ""
        self.email = info["email"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.id = id
        self.state = .loggedIn
        
    }
    
}
