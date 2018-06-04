/**
 *  @author Swarn Singh.
 */

import Foundation


struct Product {
    
    var name = ""
    var image = ""
    var detail = ""
    var id = ""
    var price = 0.0
    var isActive: Bool
    
    init(info:[String:Any],id:String) {
        
        self.name = info["name"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.id = id
        self.price = info["price"] as? Double ?? 0.0
        self.detail = info["detail"] as? String ?? ""
        self.isActive = info["isActive"] as? Bool ?? true
    }
    
}
