/**
 *  @author Swarn Singh.
 */

import UIKit

class PreferenceManager {
    private static let isLogin = "isLogin";
    
    public static func setUserLogin(isUserLogin: Bool) {
        UserDefaults.standard.set(isUserLogin, forKey: isLogin)
    }
    
    public static func isUserLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: isLogin)
    }
}
