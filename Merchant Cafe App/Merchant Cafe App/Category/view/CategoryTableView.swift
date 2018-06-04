/**
 *  @author Swarn Singh.
 */

import Foundation
import UIKit
import AlamofireImage
import Toast_Swift

extension CategoryProductViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return categoryArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let category = categoryArray[indexPath.section]
        
        let labelCell = cell?.viewWithTag(101) as! UILabel
        let imageCell = cell?.viewWithTag(102) as! UIImageView
        
        labelCell.text = category.name
        
        if category.image.count > 0{
            
            let url = URL(string:category.image)!
            
            imageCell.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder.png"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: { (response) in
                
                imageCell.contentMode = .scaleAspectFill
                
            })
            
            
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category = categoryArray[indexPath.section]
        
        if isFromCategory == false {
            let productVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.PRODUCT_VIEW_SEGUE) as! ProductViewController
            
            productVC.category = category
            productVC.categoryArray = categoryArray
            
            self.navigationController?.pushViewController(productVC, animated: true)
        }
        else {
            
            let AddCategoryVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.Category_OP_VIEW_SEGUE) as! AddCategoryFormViewController
            
            AddCategoryVC.category = category
            AddCategoryVC.categoryArray = categoryArray

            self.navigationController?.pushViewController(AddCategoryVC, animated: true)
            
        }
    }
    
}
