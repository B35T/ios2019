//
//  MenuCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol MenuCellDelegate {
    func MenuCellSelected(indexPath: IndexPath)
}

class MenuCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: MenuCellDelegate?
    var images: [UIImage]?
    let phCell = "PhotosCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: phCell, bundle: nil), forCellWithReuseIdentifier: phCell)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

}

extension MenuCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCell, for: indexPath) as! PhotosCell
        cell.thumbnailImage = images?[indexPath.item]
        cell.imageview.alpha = 0.5
        cell.useIsSelect = .highlight
        return cell
    }
}

extension MenuCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCell, for: indexPath) as! PhotosCell
        cell.isSelected = true
        self.delegate?.MenuCellSelected(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCell, for: indexPath) as! PhotosCell
        cell.isSelected = false
    }
}

extension MenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
}
