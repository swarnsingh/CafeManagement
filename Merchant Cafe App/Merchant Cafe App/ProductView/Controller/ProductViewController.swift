/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore
import MBProgressHUD

class ProductViewController: UIViewController {
    
    var category:Category?
    
    var categoryArray = [Category]()
    var productArray = [Product]()
    
    @IBOutlet weak var productCollectionView:UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            category = getProduct()
            MBProgressHUD.hide(for: self.view, animated: true)
            if (category?.products.count)! == 0 {
                self.view.makeToast("Category : \(category?.name ?? "") dont' have any products. Please add new products by click on add button ", duration: 3.0, position: .center)
            }
        } else {
            self.view.makeToast("Please check your internet connection!", duration: 1.0, position: .bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ProductViewController.btnAddPressed))
        
        self.title = category?.name
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func btnAddPressed(){
        let productVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.PRODUCT_OP_VIEW_SEGUE) as! ProductOperationsViewController
        
        productVC.categoryArray = categoryArray
        productVC.category = category
        
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: WebApi Method
    
    func getProduct() -> Category {
        self.productArray.removeAll()
        
        let unsubscribe = Firestore.firestore().collection("category").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in (snapshot?.documents)!{
                    let category = Category(info: document.data(), id: document.documentID)
                    if category.name == self.category?.name {
                        self.category = category
                        Firestore.firestore().collection("products").addSnapshotListener { (snapshot, error) in
                            
                            if error == nil {
                                
                                for document in (snapshot?.documents)! {
                                    if (category.products.contains(document.documentID)) {
                                        let product = Product(info: document.data(), id: document.documentID)
                                        self.productArray.append(product)
                                    }
                                }
                                self.productCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        unsubscribe ;
        return self.category!
    }
}
