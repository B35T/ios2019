//
//  EditorViewController.swift
//  Colr
//
//  Created by chaloemphong on 21/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class EditorViewController: UIViewController {

    var asset: PHAsset!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: CloseButton!
    
    
    enum Cells: String {
        case PresetCell
        case MenuCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: Cells.PresetCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.PresetCell.rawValue)
        self.collectionView.register(UINib(nibName: Cells.MenuCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.MenuCell.rawValue)
        self.collectionView.frame = .init(x: 0, y: view.h.minus(n: 150), width: view.w, height: 150)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear

        PHPhotoLibrary.shared().register(self)
        
        self.view.backgroundColor = .black

        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: view.w, height: view.h.minus(n: 160)))
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        self.view.addSubview(self.imageView)
        
        let closeBtn = CloseButton()
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: 10))
        self.closeBtn = closeBtn
        self.view.addSubview(self.closeBtn)
        
        self.updateStaticPhotos()
    }
    
    func updateStaticPhotos() {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        
        let s = UIScreen.main.bounds.width * UIScreen.main.scale
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: s, height: s), contentMode: .aspectFit, options: option) { (image, _) in
            self.imageView.image = image
        }
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension EditorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PresetCell.rawValue, for: indexPath) as! PresetCell
            cell.asset = asset
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MenuCell.rawValue, for: indexPath) as! MenuCell
            return cell
        default:
            fatalError()
        }
    }
}

extension EditorViewController: UICollectionViewDelegate {
    
}

extension EditorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.w, height: 80)
        default:
            return CGSize(width: view.w, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}



extension EditorViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}
