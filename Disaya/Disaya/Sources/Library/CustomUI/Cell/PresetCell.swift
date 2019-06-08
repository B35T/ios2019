//
//  PresetCell.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol PresetCellDelegate {
    func PresetDidSelect(indexPath: IndexPath)
}

class PresetCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: PresetCellDelegate?
    
    var ciimage: CIImage?
    var thumbnail: UIImage? {
        didSet {
            self.ciimage = CIImage(image: self.thumbnail!)
            self.reset()
        }
    }
    var select = IndexPath(item: 0, section: 0)
    var cells:[IndexPath: PresetPreviewCell] = [:]
    let H = ["Hue -15", "Hue +15"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.register(UINib(nibName: "PresetPreviewCell", bundle: nil), forCellWithReuseIdentifier: "PresetPreviewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
    }

    func reset() {
        self.select = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .left, animated: false)
        self.collectionView.reloadData()
    }
}

extension PresetCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pre = self.select
        self.cells[pre]?.indexPath = pre
        self.cells[pre]?.isSelected = false
        
        self.select = indexPath
        self.cells[self.select]?.indexPath = indexPath
        self.cells[self.select]?.isSelected = true
        
        self.delegate?.PresetDidSelect(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.cells[indexPath]?.indexPath = indexPath
        self.cells[indexPath]?.isSelected = false
    }
}

extension PresetCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 7
        case 2: return 6
        case 3: return 8
        case 4: return 9
        case 5: return 2
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetPreviewCell", for: indexPath) as! PresetPreviewCell
        cell.layer.cornerRadius = 3
        
        let preset = PresetLibrary()
        let result = preset.filter(indexPath: indexPath, ciimage: ciimage!)
        cell.imageview.image = UIImage(ciImage: result!)
        switch indexPath.section {
        case 0:
            cell.labelTitle.text = "NONE"
            cell.labelTitle.textColor = black
            
            if select == IndexPath(item: 0, section: 0)  { cell.isSelected = true }
        case 1: cell.labelTitle.text = "S\(indexPath.item)"; cell.labelTitle.textColor = yellow // start
        case 2: cell.labelTitle.text = "P\(indexPath.item)"; cell.labelTitle.textColor = red // 
        case 3: cell.labelTitle.text = "G\(indexPath.item)"; cell.labelTitle.textColor = black // grain
        case 4: cell.labelTitle.text = "C\(indexPath.item)"; cell.labelTitle.textColor = blue // color
        case 5: cell.labelTitle.text = self.H[indexPath.item]; cell.labelTitle.textColor = indigo // color
        default:
            break
        }
        
        self.cells.updateValue(cell, forKey: indexPath)
        return cell
    }
}

extension PresetCell: UICollectionViewDelegateFlowLayout {
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
