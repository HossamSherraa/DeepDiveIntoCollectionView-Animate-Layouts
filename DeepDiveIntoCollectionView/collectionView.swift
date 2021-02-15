//
//  collectionView.swift
//  DeepDiveIntoCollectionView
//
//  Created by Hossam on 9/11/19.
//  Copyright © 2019 Hossam. All rights reserved.
//

import UIKit
class CollectionView : UICollectionViewController {
    let layout = UICollectionViewFlowLayout()
     let context = UICollectionViewLayoutInvalidationContext()
    
    @IBAction func actionBTN(_ sender: UIBarButtonItem) {
       
        UIView.animate(withDuration: 0.1){
            self.collectionView.setCollectionViewLayout(newLayout(), animated: true)
        }
        
        
    }
    
    
    
    
    var data : [[UIImage]]  = {
        
        
        
        var temp = [[UIImage]() , [UIImage]() , [UIImage]()]
        for num in 0...29 {
            
            guard let image = UIImage(named: "\(num).jpeg") else {continue}
            
            
            switch num {
            case 0...9 : temp[0].append(image)
            case 10...19 : temp[1].append(image)
            case 20...30 : temp[2].append(image)
            default : continue
            }
            
            
        }
        
        return temp
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(myG(gesture:))))
        
       
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        
       
    }
    @objc func myG(gesture : UIPanGestureRecognizer){
        fatalError()
        switch gesture.state {
        
        
            
        case .cancelled:self.collectionView.cancelInteractiveMovement()
        case .ended :
            self.collectionView.endInteractiveMovement()
        
           
            print(gesture.location(in: self.view))
        case .changed : self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: self.view))
        default : break
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return data.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
        cell.image.image = data[indexPath.section][indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = data[sourceIndexPath.section].remove(at:sourceIndexPath.row)
        data[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
    }
    
    
    
   
    
}

