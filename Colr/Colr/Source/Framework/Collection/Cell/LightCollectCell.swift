//
//  LightCollectCell.swift
//  Colr
//
//  Created by chaloemphong on 14/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol LightCollectCellDelegate {
    func LightCollectSelect(title:String?, index:Int)
}

class LightCollectCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: LightCollectCellDelegate?
    var titles:[String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "LightCell", bundle: nil), forCellWithReuseIdentifier: "LightCell")
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

}

extension LightCollectCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightCell", for: indexPath) as! LightCell
        cell.frame.size = .init(width: 80, height: 80)
        cell.titles = self.titles?[indexPath.item]
        return cell
    }
}

extension LightCollectCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.LightCollectSelect(title: self.titles?[indexPath.item], index: indexPath.item)
    }
}

extension LightCollectCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
