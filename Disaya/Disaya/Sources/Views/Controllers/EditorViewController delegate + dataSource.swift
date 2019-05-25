//
//  EditorViewController delegate + dataSource.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

enum select:Int {
    case filter = 0
    case preset
    case tools
}


extension EditorViewControllers: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            switch self.selected {
            case .tools:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightCollectCell", for: indexPath) as! LightCollectCell
                cell.delegate = self
                cell.viewEditor = self
                cell.profile = self.profile
               
                return cell
            case .preset, .filter:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetCell", for: indexPath) as! PresetCell
                cell.delegate = self
                PHImageManager.default().requestImage(for: asset!, targetSize: .init(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (img, _) in
                    cell.thumbnail = img
                }
                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.delegate = self
            return cell
        default:
            fatalError()
        }
    }
}

extension EditorViewControllers: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: view.frame.width, height: 90)
        default:
            return .init(width: view.frame.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 0, height: 0)
    }
}
