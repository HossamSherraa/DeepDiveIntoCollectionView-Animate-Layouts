//
//  NewLayoutForContext.swift
//  DeepDiveIntoCollectionView
//
//  Created by Hossam on 9/19/19.
//  Copyright © 2019 Hossam. All rights reserved.
//

import UIKit
class newLayout : UICollectionViewLayout {
   
        
        // MARK: - Helper Types
        
        struct SectionLimit {
            let top: CGFloat
            let bottom: CGFloat
        }
        
        // MARK: - Properties
        
        var previousAttributes: [[UICollectionViewLayoutAttributes]] = []
        var currentAttributes: [[UICollectionViewLayoutAttributes]] = []
        
        var previousSectionAttributes: [UICollectionViewLayoutAttributes] = []
        var currentSectionAttributes: [UICollectionViewLayoutAttributes] = []
        
        var currentSectionLimits: [SectionLimit] = []
        
        let sectionHeaderHeight: CGFloat = 40
        
        var contentSize = CGSize.zero
        var selectedCellIndexPath: NSIndexPath?
        
        // MARK: - Preparation
    
        var counter = 0
        override func prepare() {
            super.prepare()
            print("PREPARE FOR MY WAY")
            prepareContentCellAttributes()
            prepareSectionHeaderAttributes()
        }
        
        private func prepareContentCellAttributes() {
            guard let collectionView = collectionView else { return }
            
            //================== Reset Content Cell Attributes ================
            
            previousAttributes = currentAttributes
            
            contentSize = CGSize.zero
            currentAttributes = []
            currentSectionLimits = []
            
            //================== Calculate New Content Cell Attributes ==================
            
            let width = collectionView.bounds.size.width
            var y: CGFloat = 0
            
            for sectionIndex in 0..<collectionView.numberOfSections{
                let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
                let sectionTop = y
                
                y += sectionHeaderHeight
                
                var attributesList: [UICollectionViewLayoutAttributes] = []
                
                for itemIndex in 0..<itemCount {
                    let indexPath = NSIndexPath(item: itemIndex, section: sectionIndex)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                    let size = CGSize(
                        width: width,
                        height: indexPath == selectedCellIndexPath ? 300.0 : 100.0
                    )
                    
                    attributes.frame = CGRect(x: 0, y: y, width: width, height: size.height)
                    
                    attributesList.append(attributes)
                    
                    y += size.height
                }
                
                let sectionBottom = y
                currentSectionLimits.append(SectionLimit(top: sectionTop, bottom: sectionBottom))
                
                currentAttributes.append(attributesList)
            }
            
            contentSize = CGSize(width: width, height: y)
        }
        
        private func prepareSectionHeaderAttributes() {
            guard let collectionView = collectionView else { return }
            
            //================== Reset Section Attributes ====================
            
            previousSectionAttributes = currentSectionAttributes
            currentSectionAttributes = []
            
           
            
            let width = collectionView.bounds.size.width
            
            let collectionViewTop = collectionView.contentOffset.y
            let aboveCollectionViewTop = collectionViewTop - sectionHeaderHeight
            
            for sectionIndex in 0..<collectionView.numberOfSections {
                let sectionLimit = currentSectionLimits[sectionIndex]
                
                
                let indexPath = IndexPath(item: 0, section: sectionIndex)
                
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                
                attributes.zIndex = 1
                attributes.frame = CGRect(x: 0, y: sectionLimit.top, width: width, height: sectionHeaderHeight)
                

                
                let sectionTop = sectionLimit.top
                let sectionBottom = sectionLimit.bottom - sectionHeaderHeight
                
                attributes.frame.origin.y = min(
                    max(sectionTop, collectionViewTop),
                    max(sectionBottom, aboveCollectionViewTop)
                )
                
                currentSectionAttributes.append(attributes)
            }
        }
        
    
        
   
        
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath.section][indexPath.item]
    }
        
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var attributes: [UICollectionViewLayoutAttributes] = []
            
            for sectionIndex in 0..<(collectionView?.numberOfSections ?? 0) {
                let sectionAttributes = currentSectionAttributes[sectionIndex]
                
                if rect.intersects(sectionAttributes.frame) {
                    attributes.append(sectionAttributes)
                }
                
                for item in currentAttributes[sectionIndex] where rect.intersects(item.frame) {
                    attributes.append(item)
                }
            }
            
            return attributes
        }
        
        // MARK: - Layout Attributes - Section Header Cell
        
    
        
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return currentSectionAttributes[indexPath.section]
    }
        
    
        
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return false
        }
        

        
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let invalidationContext = super.invalidationContext(forBoundsChange: newBounds) as! InvalidationContext
        
            guard let oldBounds = collectionView?.bounds else { return invalidationContext }
            guard oldBounds != newBounds else { return invalidationContext }
            
            let originChanged = !oldBounds.origin.equalTo(newBounds.origin)
            let sizeChanged = !oldBounds.size.equalTo(newBounds.size)
            
            if sizeChanged {
                invalidationContext.shouldInvalidateEverything = true
            } else {
                invalidationContext.shouldInvalidateEverything = false
            }
            
            if originChanged {
                invalidationContext.invalidateSectionHeaders = true
            }
            
            return invalidationContext
        }
        
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
            let invalidationContext = context as! InvalidationContext
            if invalidationContext.invalidateSectionHeaders {
                prepareSectionHeaderAttributes()
                
                var sectionHeaderIndexPaths: [NSIndexPath] = []
                
                for sectionIndex in 0..<currentSectionAttributes.count {
                    sectionHeaderIndexPaths.append(NSIndexPath(item: 0, section: sectionIndex))
                }
                
                
                
                invalidationContext.invalidateSupplementaryElements(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    at: sectionHeaderIndexPaths as [IndexPath]
                )
            }
            
        super.invalidateLayout(with: invalidationContext)
        }
    
    override class var invalidationContextClass: AnyClass {
        return InvalidationContext.self
    }
        // MARK: - Collection View Info
        
    override var collectionViewContentSize: CGSize{
        return contentSize
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
            guard let selectedCellIndexPath = selectedCellIndexPath else { return proposedContentOffset }
           
            var finalContentOffset = proposedContentOffset
            
        if let frame = layoutAttributesForItem(at: selectedCellIndexPath as IndexPath)?.frame {
                let collectionViewHeight = collectionView?.bounds.size.height ?? 0
                
                let collectionViewTop = proposedContentOffset.y
                let collectionViewBottom = collectionViewTop + collectionViewHeight
                
                let cellTop = frame.origin.y
                let cellBottom = cellTop + frame.size.height
                
                if cellBottom > collectionViewBottom {
                    finalContentOffset = CGPoint(x: 0.0, y: collectionViewTop + (cellBottom - collectionViewBottom))
                } else if cellTop < collectionViewTop + sectionHeaderHeight {
                    finalContentOffset = CGPoint(x: 0.0, y: collectionViewTop - (collectionViewTop - cellTop) - sectionHeaderHeight)
                }
            }
            
            return finalContentOffset
        }
    
    override var developmentLayoutDirection: UIUserInterfaceLayoutDirection {
        return .rightToLeft
    }
    
    
    
    
    }



class InvalidationContext: UICollectionViewLayoutInvalidationContext {
    var invalidateSectionHeaders = false
    var shouldInvalidateEverything = true
    override var invalidateEverything: Bool {
        return shouldInvalidateEverything
    }
}
