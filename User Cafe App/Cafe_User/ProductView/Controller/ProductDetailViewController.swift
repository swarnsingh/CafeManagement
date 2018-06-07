//
//  ProductDetailViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 30/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productImageCollectionView:UICollectionView!
    
    @IBOutlet weak var productPriceLabel:UILabel!
    
    @IBOutlet weak var productPageControl:UIPageControl!
    
    @IBOutlet weak var productNameLabel:UILabel!
    
    @IBOutlet weak var productDetailLabel:UILabel!
    
    @IBOutlet weak var addToCartButton:UIButton!
    
    @IBOutlet weak var productCountLabel:UILabel!
    
    var product:Product!
    
    var category:Category!
    
    @objc var cartProduct:CartProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = CartProduct.request()
        let predicate = NSPredicate.init(format: "id == %@", product.id)
        request.predicate = predicate
        
        let result = try? Database.persistentContainer.viewContext.fetch(request) as [CartProduct]
        
        if result!.count > 0{
            
            cartProduct = result?.first ?? nil
            
            self.productCountLabel.text = "\(result?.first?.addedQty ?? 0)"
            
            addToCartButton.isHidden = result!.first!.addedQty > 0
            
        }
        self.title = product.name
        
        productNameLabel.text = product.name
        
        productPriceLabel.text = "₹ \(product.price)"
        
        productDetailLabel.text = product.detail
        
        productPageControl.numberOfPages = product.images.count
        
        productPageControl.isHidden = true
        
        productImageCollectionView.isHidden = product.image.count == 0
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(cartButtonPressed))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartProduct), name: AppNotifications.productQtyChange.instance.name, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBadge()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let cartItem = cartProduct else{return}
        
        if cartItem.addedQty > 0{
            cartProduct?.save()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Methods

    @objc func updateCartProduct(){
        
        self.updateBadge()
        
        let context = Database.persistentContainer.viewContext
        
        let fetchRequest = CartProduct.request()
        
        let predicate = NSPredicate(format: "id == %@", product.id)
        fetchRequest.predicate = predicate
        
        do{
            
            let result = try context.fetch(fetchRequest)
            
            guard let dbItem = result.first else {
                
                cartProduct?.addedQty = 0
                addToCartButton.isHidden = false
                return
            }
            
            cartProduct?.addedQty = dbItem.addedQty
            
            self.productCountLabel.text = "\(cartProduct!.addedQty)"
            
            addToCartButton.isHidden = cartProduct!.addedQty > 0

        }catch{
            print("error")
        }
        
        
    }
    
    //MARK: Button Methods
    
    @objc func cartButtonPressed(){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.left.rawValue)
        
    }
    
    @IBAction func productQtyButtonPressed(_ sender:UIButton){
        
        if cartProduct == nil{
            
            cartProduct = Database.loadEntity(type: .cartProduct) as? CartProduct
            cartProduct?.name = product.name
            cartProduct?.category_id = category.id
            cartProduct?.price = product.price
            cartProduct?.id = product.id
            cartProduct?.category_name = category.name
            cartProduct?.image = product.image
            
            self.productQtyButtonPressed(sender)
            
            return
        }
        
        switch sender.tag {
        case 101:
            // add to cart
            cartProduct!.addedQty = 1
        case 102:
            // add product
            cartProduct!.addedQty+=1
        case 103:
            // remove product
            cartProduct!.addedQty-=1
            
        default:
            break
        }
        
        NotificationCenter.default.post(AppNotifications.productQtyChange.instance)
        
        if cartProduct!.addedQty == 0{
            
            cartProduct!.remove()
            cartProduct = nil
            addToCartButton.isHidden = false
            
        }else{
            
            self.productCountLabel.text = "\(cartProduct!.addedQty)"
            
            addToCartButton.isHidden = true
            
        }
        
    }
    
}
