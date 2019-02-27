//
//  PresetCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class PresetCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Preset:Int {
        case OG = 0
        case P
        case User
        
        static let count: Int = 3
    }
    
    let phCells = "GroupsCell"
    fileprivate var imageStatic: UIImage!
    var asset: PHAsset! {
        didSet {
            let s = 60 * UIScreen.main.scale
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: s, height: s), contentMode: .aspectFill, options: nil) { (image, _) in
                self.imageStatic = image
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.collectionView.register(UINib(nibName: phCells, bundle: nil), forCellWithReuseIdentifier: phCells)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
    }

}

extension PresetCell: UICollectionViewDelegate {
    
}

extension PresetCell: UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Preset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        
        switch Preset.init(rawValue: indexPath.item)! {
        case .OG:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! GroupsCell
            cell.items = 1
            cell.text = "OG"
            cell.identifier = "OG"
            cell.image = self.imageStatic
            return cell
        case .P:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! GroupsCell
            cell.items = 5
            cell.text = "P"
            cell.identifier = "P"
            cell.image = self.imageStatic
            return cell
        case .User:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! GroupsCell
            cell.items = 3
            cell.text = "User"
            cell.identifier = "User"
            cell.image = self.imageStatic
            return cell
        }
    }
}

extension PresetCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch Preset(rawValue: indexPath.item)! {
        case .OG:
            return CGSize(width: 1 * 60, height: 80)
        case .P:
            return CGSize(width: 5 * 60, height: 80)
        case .User:
            return CGSize(width: 3 * 60, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
}
