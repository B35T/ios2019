//
//  ImageRatioCell.swift
//  Disaya
//
//  Created by chaloemphong on 17/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol ImageRatioCellDelegate {
    func ImageRatio(ratio:setScale)
}

class ImageRatioCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ImageRatioCellDelegate?
    
    let ratioSet:[String] = ["image","free","square","3:2","2:3","4:3","3:4","16:9","9:16","21:9","9:21"]

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "RatioCell", bundle: nil), forCellWithReuseIdentifier: "RatioCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .black
    }
}

extension ImageRatioCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.ImageRatio(ratio: setScale(rawValue: indexPath.item) ?? .image)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ratioSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatioCell", for: indexPath) as! RatioCell
        cell.label.text = ratioSet[indexPath.item]
        cell.imageView.image = UIImage(named: "\(ratioSet[indexPath.item]).png")
        return cell
    }

}
