//
//  PhotosViewController.swift
//  Colr
//
//  Created by chaloemphong on 20/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
import UIKit
import Photos
import PhotosUI

public protocol PhotosViewCollectionDelegate {
    func photosResult(image: UIImage?)
}

class PhotosViewController: UICollectionViewController {
    
    fileprivate var imageManager = PHCachingImageManager()
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var count: Int = 0
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        let size = UIScreen.main.bounds
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    var delegate: PhotosViewCollectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let fetchOption = PHFetchOptions()
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption)
        
        PHPhotoLibrary.shared().register(self)
        self.resetCacheAsset()
        
        self.count = self.fetchResult.count
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    fileprivate func resetCacheAsset() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
}

extension PhotosViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = (self.count - 1) - indexPath.item
        
        let asset = self.fetchResult.object(at: index)
        
        
        let cell = UICollectionViewCell()
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = (self.count - 1) - indexPath.item
        let asset = self.fetchResult.object(at: index)
        
        self.collectionView.scrollToItem(at: .init(item: indexPath.item, section: 0), at: .top, animated: true)
        
        self.imageManager.requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFit, options: nil) { (image, _) in
            self.delegate?.photosResult(image: image)
        }
        
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width / 4 - 1
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}

extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let change = changeInstance.changeDetails(for: self.fetchResult) else {return}
        
        DispatchQueue.main.sync {
            self.fetchResult = change.fetchResultAfterChanges
            
            if change.hasIncrementalChanges {
                guard let collectionView = self.collectionView else { fatalError() }
                
                collectionView.performBatchUpdates({
                    if let removed = change.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({IndexPath(item: $0, section: 0)}))
                    }
                    
                    if let instance = change.insertedIndexes, !instance.isEmpty {
                        collectionView.insertItems(at: instance.map({IndexPath(item: $0, section: 0)}))
                    }
                    
                    change.enumerateMoves({ (fromIndex, toIndex) in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0), to: IndexPath(item: toIndex, section: 0))
                    })
                }, completion: nil)
            } else {
                self.count = self.fetchResult.count
                
                collectionView.reloadData()
            }
            
            resetCacheAsset()
        }
    }
}
