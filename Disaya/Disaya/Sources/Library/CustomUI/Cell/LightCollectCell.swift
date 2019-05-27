//
//  LightCollectCell.swift
//  Disaya
//
//  Created by chaloemphong on 23/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol LightCellDelegate {
    func LightDidSelect(indexPath: IndexPath, title:String)
}

class LightCollectCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: LightCellDelegate?
    var profile: DisayaProfile?
    
    var viewEditor: EditorViewControllers?
    var select:IndexPath?
    let tools = ["Exposure","Saturation","Contrast","Highlight","Shadow","Temperature","Vibrance","Gamma","Sharpan","Bloom", "Grain"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Initialization code")
        
        self.collectionView.register(UINib(nibName: "LightCell", bundle: nil), forCellWithReuseIdentifier: "LightCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
}

extension LightCollectCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.LightDidSelect(indexPath: indexPath, title: self.tools[indexPath.item])
    }
}

extension LightCollectCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightCell", for: indexPath) as! LightCell
        cell.layer.cornerRadius = 4
        cell.title.text = tools[indexPath.item]
        return cell
    }
    

}

extension LightCollectCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 90, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 5, height: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 5, height: 5)
    }
}

