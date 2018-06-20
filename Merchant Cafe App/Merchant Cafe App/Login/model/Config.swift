/**
 *  @author Swarn Singh.
 */

import UIKit

class Config {

    var admins = [User]()
    var currency = ""
    
    init(info:[String:Any]) {
        self.currency = info["currency"] as? String ?? ""
        let admins = info["admins"] as? [[String:Any]] ?? [[:]]
        
        for admin in admins {
            self.admins.append(User(info: admin))
        }
    }
    init() {}
}
