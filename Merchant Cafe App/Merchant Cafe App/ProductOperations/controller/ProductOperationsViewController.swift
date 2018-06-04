/**
 *  @author Swarn Singh.
 */

import UIKit
import ActionSheetPicker_3_0
import FirebaseStorage
import FirebaseFirestore
import MBProgressHUD
import Toast_Swift

class ProductOperationsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var productNameTextField: UITextField!
    
    @IBOutlet weak var productPriceTextField: UITextField!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productSaveBtn: UIButton!
    
    @IBOutlet weak var productDetailTxtView: UITextView!
    
    @IBOutlet weak var isProductActiveSwitch: UISwitch!
    
    @IBOutlet weak var isProductActiveLabel: UILabel!
    
    
    @IBOutlet weak var categoryHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var dropDownImgView: UIImageView!
    
    var product: Product?
    var categoryArray = [Category]()
    
    var category:Category?
    
    var imagePicker: UIImagePickerController?
    
    var isProductImageAvailable: Bool = false
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let categories = categoryArray.map { $0.name }
        
        ActionSheetStringPicker.show(withTitle: "Choose Category", rows: categories, initialSelection: 0, doneBlock: { (picker, selectedIndex, value) in
            
            self.categoryTextField.text = categories[selectedIndex]
            
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        
        return false
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
            self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.imagePicker?.sourceType = .camera
            self.imagePicker?.allowsEditing = true
            
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Use Photo Library", style: .default) { (action) in
            self.imagePicker?.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker?.sourceType = .photoLibrary
            self.imagePicker?.allowsEditing = true
            
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction )
        
        present(alertController, animated: true, completion: nil)
        // Your action
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        productImageView?.image = chosenImage
        isProductImageAvailable = true
        self.dismiss(animated: true, completion: nil)
    }
    
    private func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
    
    private func isProductValid() -> Bool {
        var isValid = true;
        let productName = productNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let productPrice = productPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var category: String;
        if categoryHeight.constant == 0 {
            category = (self.category?.name)!
        } else {
            category = (categoryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        }
        
        let productDetail = productDetailTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if (productName == nil || productName == Constants.BLANK) {
            showAlert("Please add product name")
            isValid = false
        } else if (productPrice == nil || productPrice == Constants.BLANK) {
            showAlert("Please add product price")
            isValid = false
        } else if !isNumeric(a: productPrice!) {
            showAlert("Please add price only")
            isValid = false
        } else if (category == Constants.BLANK) {
            showAlert("Please add category of product")
            isValid = false
        } else if (productDetail == nil || productDetail == Constants.BLANK) {
            showAlert("Please add product details")
            isValid = false
        } else if (!isProductImageAvailable) {
            showAlert("Please add image of product")
            isValid = false
        }
        
        return isValid
    }
    
    @IBAction func onProductSaveClick(_ sender: Any) {
        if isProductValid() {
            if Connectivity.isConnectedToInternet {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let document = Firestore.firestore().collection("products").document()
                var storage = Storage.storage().reference(withPath: "Product").child(document.documentID)
                if product != nil {
                    storage = Storage.storage().reference(withPath: "Product").child(product!.id)
                }
                
                let data = UIImageJPEGRepresentation((productImageView?.image)!, 0.1)
                
                let metadata = StorageMetadata(dictionary: ["contentType":"image/jpeg"])
                
                storage.putData(data!, metadata: metadata, completion: { (metadata, error) in
                    
                    if error == nil {
                        
                        storage.downloadURL(completion: { (url, errorDownload) in
                            
                            if errorDownload == nil {
                                let imageURL = url
                                let imagePathString = imageURL?.absoluteString
                                let productName = self.productNameTextField.text!
                                let productPrice = Double(self.productPriceTextField.text!)!
                                let productDetail = self.productDetailTxtView.text
                                let isProductActive = self.isProductActiveSwitch.isOn
                                
                                let data = ["name":productName,
                                            "detail":productDetail!,
                                            "price":productPrice,
                                            "isActive":isProductActive,
                                            "image":imagePathString!] as [String : Any]
                                
                                if (self.product != nil) {
                                    let documentPath = self.product?.id
                                    let document = Firestore.firestore().collection("products").document(documentPath!)
                                    document.updateData(data)
                                    
                                    var oldCategory = self.category
                                    
                                    var newCategory = self.categoryArray.filter{$0.name == self.categoryTextField.text!}.first!
                                    
                                    if oldCategory?.name != newCategory.name {
                                        let deleteCategoryDocument = Firestore.firestore().collection("category").document((oldCategory?.id)!)
                                        let index = oldCategory?.products.index(of: (self.product?.id)!)
                                        oldCategory?.products.remove(at: index!)
                                        deleteCategoryDocument.updateData(["products":oldCategory?.products as Any])
                                        
                                        let categoryDocument = Firestore.firestore().collection("category").document(newCategory.id)
                                        newCategory.products.append(document.documentID)
                                        
                                        categoryDocument.updateData(["products":newCategory.products])
                                    }
                                } else {
                                    
                                    var category = self.categoryArray.filter{$0.name == self.categoryTextField.text!}.first!
                                    
                                    let document = Firestore.firestore().collection("products").document()
                                    let categoryDocument = Firestore.firestore().collection("category").document(category.id)
                                    category.products.append(document.documentID)
                                    categoryDocument.updateData(["products":category.products])
                                    document.setData(data)
                                    
                                }
                                MBProgressHUD.hide(for: self.view, animated: true)
                                DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                                self.view.makeToast("Product Updated Succesfully", duration: 1.0, position: .bottom)
                            }
                            MBProgressHUD.hide(for: self.view, animated: true)
                        })
                    }
                })
            } else {
                self.view.makeToast("Please check internet connection!", duration: 1.0, position: .bottom)
            }
        }
    }
    
    private func gotToHomeController() {
        let homeVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.HOME_SEGUE) as! HomeViewController
        
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        productImageView?.isUserInteractionEnabled = true
        productImageView?.addGestureRecognizer(tapGestureRecognizer)
        
        if (product != nil) {
            productNameTextField?.text = product?.name
            let price:String = String(format:"%.1f", (product?.price)!)
            productPriceTextField?.text = price
            productDetailTxtView?.text = product?.detail
            categoryTextField?.text = category?.name
            isProductActiveSwitch?.isOn = (product?.isActive)!
            categoryHeight.constant = 40
            
            let url = URL(string:(product?.image)!)!
            
            productImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder.png"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: { (response) in
                self.isProductImageAvailable = true
            })
        } else {
            self.navigationItem.title = "Add Product"
            productImageView?.image = UIImage(named: "placeholder.png")
            
            if category?.name != nil {
                categoryHeight.constant = 0
                dropDownImgView.isHidden = true
                
            } else {
                categoryHeight.constant = 40
            }
        }
        categoryTextField.superview?.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
