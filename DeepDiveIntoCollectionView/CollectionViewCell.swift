//
//  CollectionViewCell.swift
//  DeepDiveIntoCollectionView
//
//  Created by Hossam on 9/11/19.
//  Copyright © 2019 Hossam. All rights reserved.
//

import UIKit
class CollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        self.image.image = nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
       let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
       
       
       attributes.transform = .init(scaleX: 1.5, y: 1.5)
       
        return attributes
    }
    
   
    
}
