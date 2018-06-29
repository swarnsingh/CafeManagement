//
//  ProfileViewController.swift
//  Merchant Cafe App
//
//  Created by Umang Gupta on 14/06/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import UIKit
import AlamofireImage
import FirebaseStorage
import MBProgressHUD

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var firstNameTextField:UITextField!
    @IBOutlet weak var lastNameTextField:UITextField!
    
    @IBOutlet weak var profilePictureButton:UIButton!
    
    var imagePath:String?
    
    var isProfilePictureChanged = false
    var isUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Profile"
        
        self.setupView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        imagePath = User.current.image
        
        if imagePath?.count ?? 0 > 0 {
            
            let url = URL(string:imagePath ?? "")
            
            profilePictureButton.af_setImage(for: .normal, url: url!)
            
        }
        firstNameTextField.text = User.current.firstName
        lastNameTextField.text = User.current.lastName
        emailTextField.text = User.current.email
        
    }
    
    //MARK: Button Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isUpdated = true
        return true
    }
    
    @IBAction func profileButtonPressed(_ sender:UIButton) {
        if profilePictureButton.image(for: .normal) != nil {
            self.showProfilePictureOption()
        } else {
            self.openImagePickerActionSheet()
        }
    }
    
    @IBAction func updateButtonPressed(_ sender:UIButton) {
        
        if isUpdated {
            
            self.validate { result in
                
                if result.isValid {
                    
                    if self.isProfilePictureChanged {
                        
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        
                        let name = User.current.firstName + ".jpg"
                        
                        let storage = Storage.storage().reference(withPath: "ProfilePicture/\(name)")
                        
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        
                        let data = UIImageJPEGRepresentation((self.profilePictureButton.imageView?.image)!, 0.1)
                        
                        storage.putData(data!, metadata: metadata, completion: { (metadata, error) in
                            
                            if error == nil {
                                storage.downloadURL(completion: { (url, error) in
                                    
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    
                                    if error == nil {
                                        self.imagePath = url?.absoluteString
                                        self.updateData()
                                        self.isUpdated = false
                                    } else {
                                        self.showAlert("Error in uploading profile picture, try again.")
                                    }
                                })
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.showAlert("Error in uploading profile picture, try again.")
                            }
                        })
                    } else {
                        self.updateData()
                        self.isUpdated = false
                    }
                } else {
                    self.showAlert(result.error)
                }
            }
            
        } else {
            self.showAlert("No edit found in your profile")
        }

    }
    
    @IBAction func changePasswordButtonPressed(_ sender:UIButton) {}
    
}

