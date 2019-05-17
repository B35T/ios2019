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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var asset: PHAsset?
    
    public var delegate: CropViewControllerDelegate?
    
    var preimage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let asset = asset {
            PHImageManager.default().requestImage(for: asset, targetSize: .init(width: view.frame.width / 2, height: view.frame.height / 2), contentMode: .aspectFit, options: nil) { (img, _) in
                self.image = img
                self.preimage = img
            }
        } else {
            print("no image")
        }
        
        self.collectionView.register(UINib(nibName: "StraightenCell", bundle: nil), forCellWithReuseIdentifier: "StraightenCell")
        self.collectionView.register(UINib(nibName: "ImageRatioCell", bundle: nil), forCellWithReuseIdentifier: "ImageRatioCell")
        self.collectionView.frame = .init(x: 0, y: view.frame.height - 190, width: view.frame.width, height: 150)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.insertSubview(self.collectionView, at: 5)
        
        let close = UIButton(frame: .init(x: 10, y: view.frame.height - 40, width: 35, height: 35))
        close.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.view.insertSubview(close, at: 6)
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

extension CropViewController: StraightenCellDelegate {
    func StraightenAction(value: Float) {
        if let cimage = CIImage(image: image!) {
            let filter = CIFilter(name: "CIStraightenFilter")
            let cal = value * Float.pi / 180
            filter?.setDefaults()
            filter?.setValue(cimage, forKey: "inputImage")
            filter?.setValue(cal, forKey: "inputAngle")
            
            self.imageView.image = UIImage(ciImage: filter!.outputImage!)
        }
    }
}

extension CropViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StraightenCell", for: indexPath) as! StraightenCell
            cell.delegate = self
            cell.slider.minimumValue = -45
            cell.slider.maximumValue = 45
            cell.slider.value = 0
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageRatioCell", for: indexPath) as! ImageRatioCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension CropViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return .init(width: view.frame.width, height: 40)
        default:
            return .init(width: view.frame.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 10, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 10, height: 10)
    }
}
