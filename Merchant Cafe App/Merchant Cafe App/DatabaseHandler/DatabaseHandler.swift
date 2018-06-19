//
//  DatabaseHandler.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreData

class Database{
    
    enum Collection:String {
        case user,admin,products,category,config,order
    }
    
    enum Entity{
        
        case cartProduct,other
        
        var rawValue:String{
            
            switch self {
            case .cartProduct:
                return "CartProduct"
            case .other:
                return "Other"
            }
            
        }
    }
    
    @available(iOS 10.0, *)
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cafe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    class func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        } else {
            // Fallback on earlier versions
        }

    }
    
    class func loadEntity(type:Entity)->NSManagedObject?{
        
        if #available(iOS 10.0, *) {
            
            let context = persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: type.rawValue, in: context)
            
            return NSManagedObject(entity: entity!, insertInto: context)
            
        } else {
            // Fallback on earlier versions
        }
        
        return nil
    }
    
    class func getDataOf(_ collection:Collection,At path:String, callback:@escaping ([String:Any]?)->Void){
        
        let database = Firestore.firestore().collection(collection.rawValue).document(path)
        
        database.getDocument { (snapshot, error) in
            
            callback(snapshot?.data())
            
        }
        
    }
    
    class func setDataAt(_ collection:Collection,With path:String, data:[String:Any]){
        
        let database = Firestore.firestore().collection(collection.rawValue).document(path)
        
        database.setData(data)
        
    }
    
}
