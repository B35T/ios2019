//
//  CollectionDataSource.swift
//  Colr
//
//  Created by chaloemphong on 19/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension EditorViewController: UICollectionViewDataSource {
    func animetion() {
        if self.checkSelect == self.selected {
            return
        }
        
        self.checkSelect = self.selected
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
            self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
        }, completion: nil)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.selected == .preset {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.LightCollectCell.rawValue, for: indexPath) as! LightCollectCell
            cell.ProcessEngineProfile = self.ProcessEngineProfile
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            switch selected {
            case .filter:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.FilterCell.rawValue, for: indexPath) as! FilterCell
                cell.Engine = self.Engine
                cell.original = self.original
                cell.thumbnails = self.thumbnail
                cell.delegate = self
                return cell
            case .preset:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PresetCell.rawValue, for: indexPath) as! PresetCell
                cell.Engine = self.Engine
                cell.origonal = self.original
                cell.thumbnails = self.thumbnail
                cell.delegate = self
                print("reload")
                return cell
            case .tools:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.LightCollectCell.rawValue, for: indexPath) as! LightCollectCell
                cell.delegate = self
                cell.viewController = self
                cell.tag = indexPath.item
                cell.titles = ["Exposure","Saturation", "Brightness","Contrast","Highlight","Shadow","Temperature","Tint","Vibrance","Gamma","Sharpan"]
                cell.ProcessEngineProfile = self.ProcessEngineProfile
                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MenuCell.rawValue, for: indexPath) as! MenuCell
            cell.delegate = self
            cell.images = [#imageLiteral(resourceName: "Filter"), #imageLiteral(resourceName: "hsl"), #imageLiteral(resourceName: "light"), #imageLiteral(resourceName: "3d"), #imageLiteral(resourceName: "crop")]
            return cell
        default:
            fatalError()
        }
    }
}

