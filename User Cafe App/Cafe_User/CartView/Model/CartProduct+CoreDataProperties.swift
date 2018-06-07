//
//  CartProduct+CoreDataProperties.swift
//  
//
//  Created by Divyanshu Sharma on 31/05/18.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func request() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var category_id: String?
    @NSManaged public dynamic var addedQty: Int16
    @NSManaged public var category_name: String?
    @NSManaged public var image: String?

}
