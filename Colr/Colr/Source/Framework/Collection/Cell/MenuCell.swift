//
//  MenuCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var image: UIImage?
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCell, for: indexPath) as! PhotosCell
        cell.thumbnailImage = image ?? #imageLiteral(resourceName: "Icon_filter")
        return cell
    }
}

extension MenuCell: UICollectionViewDelegate {
    
}

extension MenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
}
