//
//  LightCollectCell.swift
//  Colr
//
//  Created by chaloemphong on 14/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol LightCollectCellDelegate {
    func updateValueProfile(profile:ProcessEngineProfileModel?)
    func lightAction(title:String, tag: Int, value:Float, profile:ProcessEngineProfileModel?)
}

class LightCollectCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: LightCollectCellDelegate?
    var titles:[String]?
    var ProcessEngineProfile: ProcessEngineProfileModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var cells:[String:LightCell] = [:]
    var viewController:UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "LightCell", bundle: nil), forCellWithReuseIdentifier: "LightCell")
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension LightCollectCell: ValueAdjustViewControllerDelegate {
    func ValueAdjust(value: Float, title: String, tag: Int) {
        self.ProcessEngineProfile?.update(name: title, value: CGFloat(value))
        self.cells[title]?.value = value
        
        self.delegate?.lightAction(title: title, tag: tag, value: value, profile: self.ProcessEngineProfile)
        self.delegate?.updateValueProfile(profile: self.ProcessEngineProfile)
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
        cell.value = self.ProcessEngineProfile?.get(name: self.titles?[indexPath.item] ?? "")?.toFloat ?? ProcessEngine().toolmin(t: tool(rawValue: indexPath.item)!).value
        cells.updateValue(cell, forKey: self.titles?[indexPath.item] ?? "")
        return cell
    }
}

extension LightCollectCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let valueAdjust = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ValueAdjust") as! ValueAdjustViewController
        valueAdjust.tag = indexPath.item
        valueAdjust.modalPresentationStyle = .overCurrentContext
        valueAdjust.titles = self.titles?[indexPath.item] ?? ""
        valueAdjust.ProcessEngineProfile = self.ProcessEngineProfile
        let m = ProcessEngine().toolmin(t: tool(rawValue: indexPath.item)!)
        valueAdjust.defualValue = m.value
        valueAdjust.min = m.min
        valueAdjust.max = m.max
        
        valueAdjust.delegate = self
        self.viewController.present(valueAdjust, animated: true, completion: nil)
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
