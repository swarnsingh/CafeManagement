/**
 *  @author Swarn Singh.
 */

import UIKit
import FirebaseFirestore

class CategoryProductViewController: UIViewController {
    
    @IBOutlet weak var categoryListTableView:UITableView!
    
    var categoryArray = [Category]()
    
    var isFromCategory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isFromCategory {
            self.navigationController?.navigationBar.tintColor = UIColor.white
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CategoryProductViewController.btnAddPressed))
            
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CategoryProductViewController.btnAddProductPressed))
        }
        
        if Connectivity.isConnectedToInternet {
            self.getCategories()
        } else {
            self.view.makeToast("Please check your internet connection!", duration: 1.0, position: .bottom)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func btnAddPressed(){
        let AddCategoryVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.Category_OP_VIEW_SEGUE) as! AddCategoryFormViewController
            AddCategoryVC.categoryArray = categoryArray
        self.navigationController?.pushViewController(AddCategoryVC, animated: true)
    }
    
    @objc func btnAddProductPressed() {
        let productVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.PRODUCT_OP_VIEW_SEGUE) as! ProductOperationsViewController
        
        productVC.categoryArray = categoryArray
        
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}

extension CategoryProductViewController {
    
    //MARK: WebAPI Method
    
    func getCategories() {
        
        let unsubscribe = Firestore.firestore().collection("category").addSnapshotListener { (snapshot, error) in
            
            if error == nil {
                
                self.categoryArray.removeAll()
                
                for document in (snapshot?.documents)!{
                    
                    let category = Category(info: document.data(), id: document.documentID)
                    self.categoryArray.append(category)
                }
                
                self.categoryListTableView.reloadData()
                
            }
            
        }
        unsubscribe;
    }
    
}
