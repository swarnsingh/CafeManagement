//
//  HomeFirebaseListners.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 08/06/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension HomeViewController{
    
    func addListners(){
        
        self.getConfiguration()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil{
                
                self.getCategories()
                
            }else{
                
                self.listner?.remove()
                
                self.listner = nil
                
            }
            
        }
        
    }
    
    func getConfiguration(){
        
        Firestore.firestore().collection(Database.Collection.admin.rawValue).document("1").addSnapshotListener({ (document, error) in
            
            if error == nil{
                
                let phone = document?.data()!["mobile"] as? String ?? ""
                
                Constants.config.contactPhone = phone
                
            }
            
        })
        
        Firestore.firestore().collection(Database.Collection.config.rawValue).addSnapshotListener({ (snapshot, error) in
            
            if error == nil && snapshot!.documents.count > 0{
                
                let document = snapshot?.documents.first!
                
                let currency = document?.data()["currency"] as? String ?? "₹"
                
                Constants.config.currency = currency
                
            }
            
        })
        
        
    }
    
    func getCategories(){
        
        listner = Firestore.firestore().collection(Database.Collection.category.rawValue).whereField("is_active", isEqualTo: true).addSnapshotListener { (snapshot, error) in
            
            if error == nil{
                
                self.categoryArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let category = Category(info: document.data(), id: document.documentID)
                    self.categoryArray.append(category)
                    
                }
                
                self.categoryArray = self.categoryArray.filter{$0.products.count > 0}
                
                self.categoryArray = self.categoryArray.sorted(by: { (cat1, cat2) -> Bool in
                    return cat1.name.localizedCaseInsensitiveCompare(cat2.name) == .orderedAscending
                })
                
                self.categoryListTableView.reloadData()
                
            }
            
        }
        
    }
    
}
