//
//  AddCategoryFormViewController.swift
//  Merchant Cafe App
//
//  Created by Umang Gupta on 29/05/18.
//  Copyright © 2018 In Time Tec. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import AlamofireImage
import MBProgressHUD

class AddCategoryFormViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var CategoryImageView: UIImageView!
    @IBOutlet var CategoryNameField: UITextField!
    @IBOutlet var UICustomSwitch: UISwitch!
    @IBOutlet var customImagePickerButton: UIButton!
    @IBOutlet var CustomAddButton: UIButton!
    var category:Category?
    var categoryArray = [Category]()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        customImagePickerButton.imageView?.contentMode = .scaleAspectFill
        customImagePickerButton.imageView?.clipsToBounds = true
        CustomAddButton.backgroundColor = UIColor.init(red: 184/255.0, green: 23/255.0, blue: 72/255.0, alpha: 1.0)
        self.title = "Add Category"
        //var categoryId = category?.id
        
        if category != nil {
            self.title = "Edit"
            CustomAddButton.setTitle("Update", for: .normal)
            CategoryNameField.text = category?.name
            UICustomSwitch.setOn(category!.is_active, animated: true)
            customImagePickerButton.setTitle("", for: .normal)
            
            let url = URL(string:category!.image)!
            
            //customImagePickerButton.af_setImage(for: .normal, url: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, completion: nil)
            CategoryImageView.af_setImage(withURL: url)
            
            CustomAddButton.addTarget(self, action: #selector(self.updateButton), for: .touchUpInside)
            
        }else{
            //customImagePickerButton.setImage(#imageLiteral(resourceName: "imageBackground.jpg"), for: .normal)
            
            CustomAddButton.addTarget(self, action: #selector(self.submitButton), for: .touchUpInside)
        }
        
        UICustomSwitch.addTarget(self, action: #selector(actionSwitch(sender:)), for: .valueChanged)
        
        customImagePickerButton.addTarget(self, action: #selector(self.selectImagePicker), for: .touchUpInside)
        
        
        
        // Do any additional setup after loading the view.
    }
    //MARK: Defination for switch ON/Off button action
    @objc func actionSwitch(sender: AnyObject) {
        if UICustomSwitch.isOn {
            UICustomSwitch.setOn(false, animated: true)
            //print("ON")
            
        } else {
            UICustomSwitch.setOn(true, animated: true)
            //print("OFF")
        }
    }
    
    @objc func selectImagePicker() {
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func updateButton(){
       
        let names = categoryArray.map{$0.name.lowercased()}
        if CategoryNameField.text?.isEmpty ?? true {
            showAlert(message: "Please enter category name!")
            print("error")
            return
        }
        else if CategoryNameField.text != category?.name && names.contains((CategoryNameField.text?.lowercased())!){
            
            showAlert(message: "Category Already exist! choose another name")
            return
            
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let storage = Storage.storage().reference(withPath: "Category").child(category!.id)
            
            let data = UIImageJPEGRepresentation((CategoryImageView?.image)!, 0.1)
            
            let metadata = StorageMetadata(dictionary: ["contentType":"image/jpeg"])
            
            storage.putData(data!, metadata: metadata, completion: { (metadata, error) in
                
                if error == nil{
                    
                    storage.downloadURL(completion: { (url, errorDownload) in
                        
                        if errorDownload == nil{
                            
                            let imageURL = url
                            let imagePathString = imageURL?.absoluteString
                            let categoryName = self.CategoryNameField.text!
                            let switchValue = self.UICustomSwitch.isOn
                            
                            let data = ["name":categoryName,
                                        "is_active":switchValue,
                                        "image":imagePathString!] as [String : Any]
                            let document = Firestore.firestore().collection("category").document(self.category!.id)
                            document.updateData(data)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlert("Category Updated Successfully", callback: {
                                
                                let vc = self.navigationController?.viewControllers[1]
                                self.navigationController?.popToViewController(vc!, animated: true)
                            })
                            
                            
                        }
                        
                    })
                    
                }
                
            })
        }
        
        
    }
    
    @objc func submitButton() {
        
        let names = categoryArray.map{$0.name.lowercased()}
        
        if CategoryNameField.text?.isEmpty ?? true {
            showAlert(message: "Please enter category name!")
            print("error")
            return
        }
        else if CategoryImageView.image == nil {
            showAlert(message: "Please add an image!")
            print("error")
            return
            
        }else if names.contains((CategoryNameField.text?.lowercased())!){
            showAlert(message: "Category Already exist! choose another name")
            
            return
            
        }
        else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let document = Firestore.firestore().collection("category").document()
            
            let storage = Storage.storage().reference(withPath: "Category").child(document.documentID)
            
            let data = UIImageJPEGRepresentation((CategoryImageView?.image)!, 0.1)
            
            let metadata = StorageMetadata(dictionary: ["contentType":"image/jpeg"])
            
            storage.putData(data!, metadata: metadata, completion: { (metadata, error) in
                
                if error == nil{
                    
                    storage.downloadURL(completion: { (url, errorDownload) in
                        
                        if errorDownload == nil{
                            
                            let imageURL = url
                            let imagePathString = imageURL?.absoluteString
                            let categoryName = self.CategoryNameField.text!
                            let switchValue = self.UICustomSwitch.isOn
                            
                            let data = ["name":categoryName,
                                        "is_active":switchValue,
                                        "image":imagePathString!] as [String : Any]
                            
                            document.setData(data)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlert("Category Added Successfully", callback: {
                                
                                let vc = self.navigationController?.viewControllers[1]
                                self.navigationController?.popToViewController(vc!, animated: true)
                            })
                            
                            
                        }
                        
                    })
                    
                }
                
            })
        }
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //set image to button
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        CategoryImageView.image = image
        customImagePickerButton.setTitle("", for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showAlert(message:String?) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
