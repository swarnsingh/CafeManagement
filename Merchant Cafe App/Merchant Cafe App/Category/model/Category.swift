/**
 *  @author Swarn Singh.
 */

import Foundation

struct Category {
    
    var id = ""
    var name = ""
    var products = [String]()
    var image = ""
    var is_active = false
    
    
    init(info:[String:Any],id:String) {
        
        self.name = info["name"] as? String ?? ""
        self.image = info["image"] as? String ?? ""
        self.id = id
        self.products = info["products"] as? [String] ?? []
        self.is_active = info["is_active"] as? Bool ?? false
        
    }
    
}
