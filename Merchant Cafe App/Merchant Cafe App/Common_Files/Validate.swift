/**
 *  @author Swarn Singh.
 */

import UIKit

extension UITextField{
    
    func isValidEmail()->Bool{
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self.text!)
        
    }
    
    func isValidPassword()->Bool{
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        
        return passwordTest.evaluate(with: self.text!)
    }
    
}
