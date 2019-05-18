//
//  HSLViewController DataSource + Delegate.swift
//  Disaya
//
//  Created by chaloemphong on 18/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension HSLViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.colorCell[indexPath.item]?.isSelected = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.HSLColors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorHSLCell", for: indexPath) as! HSLCell
        cell.backgroundColor = .clear
        cell.colorView.backgroundColor = Color().HSLColors[indexPath.item]
        cell.colorView.layer.cornerRadius = 22
        self.colorCell.updateValue(cell, forKey: indexPath.item)
        if indexPath.item == select {
            cell.isSelected = true
        }
        
        return cell
    }
}


extension HSLViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 5, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 5, height: 25)
    }
}
