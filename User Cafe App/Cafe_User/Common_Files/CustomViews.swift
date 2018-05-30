//
//  CustomViews.swift
//  ITT Cafe
//
//  Created by Divyanshu Sharma on 22/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView:UIImageView{
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = .clear{
        
        didSet{
            
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
            
        }
        
    }
    
}

class CustomTextField:UITextField{
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var leftPadding:CGFloat = 0.0{
        
        didSet{
            
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.size.height))
            self.leftViewMode = .always
            
        }
        
    }
    
    @IBInspectable var placeholderColor:UIColor = .clear{
        
        didSet{
            
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = .clear{
        
        didSet{
            
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
            
        }
        
    }
    
}

class CustomView:UIView{
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = .clear{
        
        didSet{
            
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
            
        }
        
    }
    
}

class CustomButton:UIButton{
    
    @IBInspectable var cornerRadius:CGFloat = 0.0{
        
        didSet{
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
            
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = .clear{
        
        didSet{
            
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
            
        }
        
    }
    
}

extension UIViewController{
    
    func showAlert(_ text:String){
        
        self.showAlert("Alert", text)
        
    }
    
    func showAlert(_ text:String, callback:@escaping ()->Void){
        
        let alertController = UIAlertController.init(title: "Alert", message: text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            callback()
            
        })
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(_ title:String, _ text:String){
        
        let alertController = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("ok pressed")
        })
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertController(_ type:UIAlertControllerStyle, title: String , text:String , options:[String], callback:@escaping (Int)->Void){
        
        let alertController = UIAlertController.init(title: "Alert", message: text, preferredStyle: type)

        if options.count > 0{
            
            for i in 0..<options.count{
                
                let action = UIAlertAction(title: options[i], style: .default, handler: { (action) in
                    
                    callback(i)
                    
                })
                
                alertController.addAction(action)
                
            }
            
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
                callback(11)
                
            })
            
            alertController.addAction(action)
            
        }
 
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
