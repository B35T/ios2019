//
//  LightCollectCell.swift
//  Disaya
//
//  Created by chaloemphong on 23/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol LightCellDelegate {
    func LightDidSelect(indexPath: IndexPath)
}

class LightCollectCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: LightCellDelegate?
    var profile: DisayaProfile? {
        didSet {
            self.reset()
        }
    }
    
    let tools = ["Exposure","Saturation","Contrast","Highlight","Shadow","Temperature","Vibrance","Gamma","Sharpan","Bloom", "Grain"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib(nibName: "LightCell", bundle: nil), forCellWithReuseIdentifier: "LightCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
    }
    
    func reset() {
        self.collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .left, animated: false)
        self.collectionView.reloadData()
    }
}

extension LightCollectCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.LightDidSelect(indexPath: indexPath)
    }
}

extension LightCollectCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightCell", for: indexPath) as! LightCell
        cell.layer.cornerRadius = 3
        let m = profile?.valueTools(t: tool(rawValue: indexPath.item)!)
        cell.value.text = String(format: "%0.0f", m ?? 0)
        cell.title.text = tools[indexPath.item]
        return cell
    }
}

extension LightCollectCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 60, height: 80)
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

