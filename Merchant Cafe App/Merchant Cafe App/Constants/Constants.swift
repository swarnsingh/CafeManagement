/**
 *  @author Swarn Singh.
 */

import Foundation
import FirebaseFirestore

class Constants {
    public static let db: Firestore = Firestore.firestore()
    
    public static let HOME_SEGUE = "HomeViewController"
    
    public static let LOGIN_SEGUE = "LoginViewController"
}
