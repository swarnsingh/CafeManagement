//
//  ProductViewController.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductViewController: UIViewController {

    var cateogry:Category!
    
    var productArray = [Product]()
    
    @IBOutlet weak var productCollectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = cateogry.name
        self.getProduct()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(cartButtonPressed))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: AppNotifications.productQtyChange.instance.name, object: nil)
        
        self.updateBadge()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBadge()

    }
    
    //MARK: Button Methods
    
    @objc func cartButtonPressed(){
        
        Constants.sideMenuController.toggle(swipeDirection: SwipeDirection.left.rawValue)
        
    }

    //MARK: WebApi Method
    
    func getProduct(){
        Firestore.firestore().collection(Database.Collection.products.rawValue).addSnapshotListener { (snapshot, error) in
            
            if error == nil{
            
                self.productArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    if (self.cateogry.products.contains(document.documentID)){
                        
                        let product = Product(info: document.data(), id: document.documentID)
                        self.productArray.append(product)
                        
                    }
                    
                }
                
                self.productCollectionView.reloadData()
                
            }
            
        }
        
        
    }
    
    
}
