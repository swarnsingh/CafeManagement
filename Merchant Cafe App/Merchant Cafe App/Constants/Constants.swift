/**
 *  @author Swarn Singh.
 */

import Foundation
import FirebaseFirestore

class Constants {
    static let AppName = "ITT Cafe"
    
    static let screenHeight = UIScreen.main.bounds.height
    
    static let screenWidth = UIScreen.main.bounds.width
    
    public static let db: Firestore = Firestore.firestore()
    
    public static let HOME_SEGUE = "HomeViewController"
    
    public static let LOGIN_SEGUE = "LoginViewController"
}
