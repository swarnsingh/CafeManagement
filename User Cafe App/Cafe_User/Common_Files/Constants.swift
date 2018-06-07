//
//  Constants.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit
import DualSlideMenu

typealias ValidationResult = (error:String,isValid:Bool)

enum SuccessMessage{
    
    case passwordResetMail,userCreated,loginSuccessfull
    
    var stringValue:String{
        
        switch self {
            
        case .passwordResetMail:
            return "Password reset mail has been sent successfully. Please check your inbox."

        case .userCreated:
            return "User has been registered successfully. We have sent you a verification mail, Verify your mail to login."
            
        case .loginSuccessfull:
            return "Login Successfull."
        }
        
    }
    
}

enum ErrorMessage{
    
    case emptyEmail,invalidEmail,emptyPassword,invalidPassword
    case emptyFirstName,emptyLastName,passwordNotMatch,verifyEmail
    
    var stringValue:String{
        
        switch self {
        case .emptyEmail:
            return "Please enter email address."
        case .invalidEmail:
            return "Please enter valid email address."
        case .emptyPassword:
            return "Please enter password."
        case .invalidPassword:
            return "Password should contain atleast 1 capital, 1 digit and 1 special character with minimum lenght of 8 characters."
        case .emptyFirstName:
            return "Please enter first name."
        case .emptyLastName:
            return "Please enter last name."
        case .passwordNotMatch:
            return "Password and confirm password not match."
        case .verifyEmail:
            return "Your email is not verified. Please verify it first."
        }
        
    }
    
}

enum AppNotifications:String{
    
    case logout,login,productQtyChange
    
    var instance:Notification{
        
        return Notification(name: Notification.Name(self.rawValue))
        
    }
    
}

enum AppStoryBoard:String{
    
    case Login,Main
    
    var instance:UIStoryboard{
        
        return UIStoryboard(name: self.rawValue, bundle: nil)
        
    }
    
}

class Constants: NSObject {
    
    static let AppName = "ITT Cafe"
    
    static let screenHeight = UIScreen.main.bounds.height

    static let screenWidth = UIScreen.main.bounds.width

    static var sideMenuController:DualSlideMenuViewController!
}

enum SwipeDirection:String{

    case left,right
}



