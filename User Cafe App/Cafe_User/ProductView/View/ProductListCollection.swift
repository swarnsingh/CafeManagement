//
//  ProductCollection.swift
//  Cafe_User
//
//  Created by Divyanshu Sharma on 25/05/18.
//  Copyright © 2018 Divyanshu Sharma. All rights reserved.
//

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
        
        if prodcut.image.count > 0{
            
            let url = URL(string:prodcut.image)!
            
            imageCell.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder.png"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: { (response) in
                
                imageCell.contentMode = .scaleAspectFill
                
            })
            
            
        }
        
        labelCell.text = prodcut.name
        priceCell.text = "₹ \(prodcut.price)"
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productDetailVC = AppStoryBoard.Main.instance.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailViewController
        
        let prodcut = productArray[indexPath.item]

        productDetailVC.product = prodcut
        
        productDetailVC.category = self.cateogry!
        
        self.navigationController?.pushViewController(productDetailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: Constants.screenWidth/2-10, height: 200)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return .zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
}
