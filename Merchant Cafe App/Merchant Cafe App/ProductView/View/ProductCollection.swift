/**
 *  @author Swarn Singh.
 */

import Foundation
import UIKit
import AlamofireImage

extension ProductViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let prodcut = productArray[indexPath.item]
        
        let labelCell = cell.viewWithTag(101) as! UILabel
        let priceCell = cell.viewWithTag(103) as! UILabel
        let imageCell = cell.viewWithTag(102) as! UIImageView
        
        if prodcut.image.count > 0 {
            
            let url = URL(string:prodcut.image)!
            
            imageCell.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder.png"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: { (response) in
                
                imageCell.contentMode = .scaleAspectFill
                
            })
        }
        
        labelCell.text = prodcut.name
        priceCell.text = "₹ \(prodcut.price)"
        
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: Constants.screenWidth/2, height: 200)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let product = productArray[indexPath.row]
        print(product)
        
        let productVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: Constants.PRODUCT_OP_VIEW_SEGUE) as! ProductOperationsViewController
        
        productVC.product = product
        productVC.categoryArray = categoryArray
        productVC.category = category
        
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}
