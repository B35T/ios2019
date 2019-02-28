//
//  PresetCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

public protocol PresetCellDelegate {
    func PresetSelectItem(indexPath: IndexPath, identifier: String)
}

class PresetCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    enum Preset:Int {
        case OG = 0
        case P = 1
        case User = 2
    }
    
    var delegate: PresetCellDelegate?
    
    let phCells = "PhotosCell"
    var thumbnails: UIImage!
    var asset: PHAsset!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: phCells, bundle: nil), forCellWithReuseIdentifier: phCells)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

}

extension PresetCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var str = ""
        switch Preset(rawValue: indexPath.section)! {
        case .OG:
            str = "OG"
        case .P:
            str = "P"
        case .User:
            str = "U"
        }
        self.delegate?.PresetSelectItem(indexPath: indexPath, identifier: str)
    }
}

extension PresetCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Preset(rawValue: section)! {
        case .OG:
            return 1
        case .P:
            return 10
        case .User:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Preset.init(rawValue: indexPath.section)! {
        case .OG:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! PhotosCell
            cell.thumbnailImage = thumbnails
            cell.addText(str: "OG")
            cell.useIsSelect = .color
            cell.layer.cornerRadius = 4
            return cell
        case .P:
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! PhotosCell
            cell.thumbnailImage = thumbnails
            cell.addText(str: "P\(indexPath.item)")
            cell.useIsSelect = .color
            cell.layer.cornerRadius = 4
            return cell
        case .User:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! PhotosCell
            cell.thumbnailImage = thumbnails
            cell.addText(str: "U\(indexPath.item)")
            cell.useIsSelect = .color
            cell.layer.cornerRadius = 4
            return cell
        }
    }
}

extension PresetCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 0)
    }
}
