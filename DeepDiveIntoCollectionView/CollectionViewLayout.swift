//
//  CollectionViewLayout.swift
//  DeepDiveIntoCollectionView
//
//  Created by Hossam on 9/11/19.
//  Copyright © 2019 Hossam. All rights reserved.
//

import UIKit
class CollectionViewLayout : UICollectionViewLayout {
    var numberOfColumns : CGFloat = 3
    var contentHeight : CGFloat = 0
    var itemWidth : CGFloat = 0
    var offset = CGPoint.zero
    var cache = [[UICollectionViewLayoutAttributes]]()
    var indexPathsToInsert = [IndexPath]()
    var indexPathToDelete = [IndexPath]()
    
    
    var headerCache  = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize{
        return CGSize.init(width: self.collectionView!.bounds.width, height: contentHeight)
    }
    
  
    override func prepare() {
        super.prepare()
       
      self.contentHeight = 0
            self.cache.removeAll()
        self.headerCache.removeAll()
        
        
            guard let collectionView = self.collectionView else {return}
        
            var frame = CGRect.zero
            var currentColumn : CGFloat = 0
            self.itemWidth = (collectionView.bounds.width  / numberOfColumns)
        for section in 0..<self.collectionView!.numberOfSections{
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
           
            let headerIndexPath = IndexPath(item: 100, section: section)
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndexPath)
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                 frame = CGRect(x: frame.minX, y: frame.minY, width:itemWidth, height: itemWidth)
                attributes.frame = frame
                if currentColumn == numberOfColumns-1 {
                    
                    frame = CGRect(x: 0, y: frame.minY + itemWidth, width:itemWidth, height: itemWidth)
                    

                    currentColumn = 0
                }
                else {
                   
                    frame = CGRect(x: frame.minX + itemWidth, y: frame.minY, width:itemWidth, height: itemWidth)
                    currentColumn += 1
                }
                headerAttributes.frame = CGRect(x: frame.minX, y: frame.minY, width: collectionView.bounds.width, height: 30)
                contentHeight = frame.maxY
                sectionAttributes.append(attributes)
                
                
                
            }
            
            
            
            if currentColumn == 0 {
                frame = CGRect(x: 0, y: frame.minY + 30 , width:itemWidth, height: itemWidth)
                headerAttributes.frame = .init(x: 0, y: frame.minY - 30 , width: collectionView.bounds.width, height: 30)
            }else {
                currentColumn = 0
                frame = CGRect(x: 0, y: frame.maxY + 30 , width:itemWidth, height: itemWidth)
                headerAttributes.frame = .init(x: 0, y: frame.minY - 30 , width: collectionView.bounds.width, height: 30)}
            headerCache.append(headerAttributes)
            cache.append(sectionAttributes)
            
            
        }
        
        
        
    }
    
   
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        
        super.prepare(forAnimatedBoundsChange: oldBounds)
        
         print("Called")
       
    }
    
    override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
        print("Finished")
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {

           self.indexPathsToInsert = updateItems.filter{$0.updateAction == .insert}.map{$0.indexPathAfterUpdate!}
            self.indexPathToDelete = updateItems.filter{$0.updateAction == .delete}.map{$0.indexPathBeforeUpdate!}
        
        
       
        
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds != self.collectionView?.bounds
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      
        return headerCache[indexPath.section]
        }
    
   
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
       let _ =  cache.map{result.append(contentsOf: $0)}
       let _ =  headerCache.map{result.append($0)}
        return result.filter{$0.frame.intersects(rect)}
    }
    

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
       
        return cache[indexPath.section][indexPath.row]
    }
    

    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
      
        return proposedContentOffset
    }
    
   
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes =  super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        attributes.transform = .init(scaleX: 1.5, y: 1.5)
        attributes.alpha = 0.9
        return attributes
    }
    
    
    
    override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        let context =  super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        if targetPosition != previousPosition {
            context.invalidateItems(at: targetIndexPaths)
           
          
            
        }
       
        return context
        
    }
   
    
    
    
}
