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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = product.name
        
        productNameLabel.text = product.name
        
        productPriceLabel.text = "₹ \(product.price)"
        
        productDetailLabel.text = product.detail
        
        productPageControl.numberOfPages = product.images.count

        productPageControl.isHidden = true
        
        productImageCollectionView.isHidden = product.image.count == 0
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Methods
    
    @IBAction func productQtyButtonPressed(_ sender:UIButton){
        
//        switch sender.tag {
//        case 101:
//            // add to cart
//            cartProduct.addedQty = 1
//            
//        case 102:
//            // add product
//            cartProduct.addedQty+=1
//        case 103:
//            // remove product
//            cartProduct.addedQty-=1
//        default:
//            break
//        }
        
    }
    
}
