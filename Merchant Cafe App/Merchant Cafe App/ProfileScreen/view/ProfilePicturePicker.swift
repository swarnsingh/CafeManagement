//
//  ProfilePicturePicker.swift
//  Cafe_User
//
//  Created by Umang Gupta on 14/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//


import Foundation
import UIKit

extension ProfileViewController{
    
    //MARK: ImagePicker Delegates
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        isProfilePictureChanged = true

        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        profilePictureButton.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Picker Action
    
    func showProfilePictureOption(){
        
        self.showAlertController(.actionSheet, title: "Option:", text: "Select an option", options: ["Remove profile picture","Set a new one"]) { (tappedIndex) in

            if tappedIndex == 0{
                
                self.imagePath = ""
                self.profilePictureButton.setImage(nil, for: .normal)
                
            }else if tappedIndex == 1{
                
                self.openImagePickerActionSheet()
                
            }
            
        }
        
    }
    
    func openImagePickerActionSheet(){
        
        self.showAlertController(.actionSheet, title: "Option:", text: "Select an option to set profile picture", options: ["Take from camera","Choose from gallery"]) { (tappedIndex) in
            
            if tappedIndex < 2{
                
                let imagepicker = UIImagePickerController()
                imagepicker.delegate = self
                imagepicker.allowsEditing = true
                imagepicker.sourceType = (tappedIndex == 0) ? .camera : .photoLibrary

                self.present(imagepicker, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}
