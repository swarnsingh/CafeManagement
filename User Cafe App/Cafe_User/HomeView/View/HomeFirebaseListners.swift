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
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil{
                
                self.getCategories()
                
            }else{
                
                self.listner?.remove()
                
                self.listner = nil
                
            }
            
            
        }
        
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
