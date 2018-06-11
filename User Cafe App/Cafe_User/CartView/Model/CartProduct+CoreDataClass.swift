//
//  CartProduct+CoreDataClass.swift
//  
//
//  Created by Divyanshu Sharma on 31/05/18.
//
//

import Foundation
import CoreData

public class CartProduct: NSManagedObject {

    func save(){
        
        let context = Database.persistentContainer.viewContext
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }

    }
    
    class func getForProductID(id:String)->CartProduct{
        
        let request = CartProduct.request()
        let predicate = NSPredicate.init(format: "id == %@", id)
        request.predicate = predicate
        
        let result = try? Database.persistentContainer.viewContext.fetch(request) as [CartProduct]
        
        if result!.count > 0{
            
            return result!.first!
            
        }else{
            
            return Database.loadEntity(type: .cartProduct) as! CartProduct
            
        }
        
    }
    
    func remove(){
        
        let context = Database.persistentContainer.viewContext

        do{
            
            try self.validateForDelete()
            
            context.delete(self)
            
            try context.save()
            
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    class func getTotalCount()->Int{
        
        let context = Database.persistentContainer.viewContext

        let fetchRequest = CartProduct.request()
        
        let result = try? context.fetch(fetchRequest)
        
        guard let products = result else { return 0 }
        
        return products.count
        
    }
    
    var jsonRepresentation:[String:Any]{
        
        return ["id":id ?? "",
                "price":price,
                "quantity":addedQty,
                "image":image ?? "",
                "name":name ?? ""]
        
    }
    
}
