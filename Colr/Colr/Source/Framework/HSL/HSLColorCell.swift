//
//  HSLColorCell.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLColorCellDelegate {
    func HSLColorSelect(HSL:Any?, index:Int)
}

class HSLColorCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    let screen = UIScreen.main.bounds
    let color = Color()
    
    var delegate: HSLColorCellDelegate?
    
    var select = 0 {
        didSet {
            let color = Color.HSLColorSet.init(rawValue: self.select)
            self.delegate?.HSLColorSelect(HSL: color, index: self.select)
        }
    }
    var colors:[Int:ColorCell] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.collectionView.frame = .init(x: 0, y: 0, width: screen.width, height: 50)
        self.collectionView.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear
    }

}

extension HSLColorCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
        cell.isSelected = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pre = self.select
        self.colors[pre]?.isSelected = false
        
        self.select = indexPath.item
        self.colors[self.select]?.isSelected = true
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
//
//        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: IndexPath(item: select, section: 0)) as! ColorCell
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.HSLColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.view.backgroundColor = color.HSLColors[indexPath.item]
        cell.view.layer.cornerRadius = 22
        colors.updateValue(cell, forKey: indexPath.item)
        if indexPath.item == select {
            cell.isSelected = true
        }
        return cell
    }
    
    
}

extension HSLColorCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
}
