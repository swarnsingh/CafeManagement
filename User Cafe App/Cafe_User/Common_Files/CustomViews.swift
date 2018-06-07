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
    
    @IBInspectable var shadowRadius:CGFloat = 0.0{
        
        didSet{
            
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
            self.layer.shadowOpacity = 1.0
            self.layer.shadowOffset = CGSize(width: 10, height: 10)
        }
        
    }
    
    @IBInspectable var shadowColor:UIColor = .clear{
        
        didSet{
            
            self.layer.shadowColor = shadowColor.cgColor
            
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
    
    @objc func updateBadge(){
        
        var badgeCount = 0
        
        if User.current.state == .loggedIn{
            
            badgeCount = CartProduct.getTotalCount()
            
        }
        
        self.navigationItem.rightBarButtonItem?.addBadge(number: badgeCount, withOffset: .zero, andColor: .red, andFilled: true)
        
    }
    
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
        
        let alertController = UIAlertController.init(title: title, message: text, preferredStyle: type)

        if options.count > 0{
            
            for i in 0..<options.count{
                
                let action = UIAlertAction(title: options[i], style: .default, handler: { (action) in
                    
                    callback(i)
                    alertController.dismiss(animated: true, completion: nil)

                })
                
                alertController.addAction(action)
                
            }
            
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
                callback(11)
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(action)
            
        }
 
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}
