//
//  OverlayViewController.swift
//  Colr
//
//  Created by chaloemphong on 19/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol OverlayViewControllerDelegate {
    func OverlaySelected(image:UIImage)
}

open class OverlayViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var delegate: OverlayViewControllerDelegate?
    
    
    override open func loadView() {
        super.loadView()
        
    }
    
    let imgs = ["Art1.jpg", "Art2.jpg","Art3.jpg","lightning.jpg","bokeh.jpg","bokeh2.jpg"]
    var cell = "PhotosCell"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: cell, bundle: nil), forCellWithReuseIdentifier: cell)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension OverlayViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.OverlaySelected(image: UIImage(named: self.imgs[indexPath.item])!)
        self.dismiss(animated: true, completion: nil)
    }
}

extension OverlayViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cell, for: indexPath) as! PhotosCell
        cell.thumbnailImage = UIImage(named: self.imgs[indexPath.item])
        return cell
    }
}

extension OverlayViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.w / 4 - 1
        return .init(width: w, height: w)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 30, height: 30)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 30, height: 30)
    }
}
