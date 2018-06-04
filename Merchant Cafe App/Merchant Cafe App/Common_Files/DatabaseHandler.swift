/**
 *  @author Swarn Singh.
 */

import Foundation
import FirebaseFirestore

class FireDatabase{
    
    enum Collection:String {
        case user,admin,products,category,config
    }
    
    class func getDataOf(_ collection:Collection,At path:String, callback:@escaping ([String:Any]?)->Void){
        
        let database = Firestore.firestore().collection(collection.rawValue).document(path)
        
        database.getDocument { (snapshot, error) in
            
            callback(snapshot?.data())
            
        }
        
    }
    
    class func setDataAt(_ collection:Collection,With path:String, data:[String:Any]){
        
        let database = Firestore.firestore().collection(collection.rawValue).document()
        
        database.updateData(["asdf":"asdf"])
        
        //category["products"] = data
        
        database.setData(data)
        
    }
    
}
