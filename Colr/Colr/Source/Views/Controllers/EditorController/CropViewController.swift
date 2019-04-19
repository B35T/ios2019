//
//  CropingViewController.swift
//  Colr
//
//  Created by chaloemphong on 9/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

public protocol CropViewControllerDelegate {
    func cropResult(image:UIImage, zone:CGRect)
}


class CropViewController: CroprViewController {
    
    var asset: PHAsset!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeBtn: CloseButtonIcon!
    @IBOutlet weak var chooseBtn: ChooseButtonIcon!
    @IBOutlet weak var labelTitle: UILabel!
    
    public var delegate: CropViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        
        
        PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 1000, height: 1000), contentMode: .aspectFit, options: nil) { (img, _) in
            self.image = img
        }
        
        let closeBtn = CloseButtonIcon()
        self.closeBtn = closeBtn
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: view.h - 60))
        
        let chooseBtn = ChooseButtonIcon()
        self.chooseBtn = chooseBtn
        chooseBtn.addTarget(self, action: #selector(cropAction), for: .touchUpInside)
        chooseBtn.add(view: view, .init(x: view.w - 60, y: view.h - 60))
        
        self.view.backgroundColor = .black
        self.view.isUserInteractionEnabled = true
        
        self.collectionView.frame = .init(x: 0, y: view.h - 150, width: view.w, height: 100)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.insertSubview(self.collectionView, at: 5)
    }
    
    @objc internal func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func cropAction() {
        if let image = self.cropping() {
            self.delegate?.cropResult(image: image, zone: self.cropZone)
            self.dismiss(animated: true, completion: nil)
        } else {
            print("error")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension CropViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.isSelected = true
        
        self.scaleRatio = setScale(rawValue: indexPath.item) ?? setScale.free
    }
}

extension CropViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scaleRatio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.isSelected = false
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.frame.size = .init(width: 40, height: 60)
        let image = [#imageLiteral(resourceName: "Reset"),#imageLiteral(resourceName: "Free"),#imageLiteral(resourceName: "1:1"),#imageLiteral(resourceName: "3:2"),#imageLiteral(resourceName: "2:3"),#imageLiteral(resourceName: "4:3"),#imageLiteral(resourceName: "3:4"),#imageLiteral(resourceName: "16:9"),#imageLiteral(resourceName: "9:16"),#imageLiteral(resourceName: "21:9"),#imageLiteral(resourceName: "9:21")]
        cell.imageview.image = image[indexPath.item]
        cell.imageview.alpha = 0.5
        cell.useIsSelect = .highlight
        return cell
    }
}

extension CropViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
}
