//
//  AssetGridViewController.swift
//  BrowsPhotos
//
//  Created by chaloemphong on 23/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos
import PhotosUI



class AssetGridViewController: UICollectionViewController {

    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    var availableWidth: CGFloat = 0
    
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    fileprivate var imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize:CGSize!
    fileprivate var perviousPreheatRect = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetCacheAssets()
        PHPhotoLibrary.shared().register(self)
        
        if fetchResult == nil {
            let allPhotosOption = PHFetchOptions()
//            allPhotosOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOption)
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        
        if availableWidth != width {
            availableWidth = width
            let columnCount = (availableWidth / 80).rounded(.towardZero)
            let itemLength = (availableWidth - columnCount - 1) / columnCount
            collectionViewFlowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scale = UIScreen.main.scale
        let cellSize = collectionViewFlowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        // Add a button to the navigation bar if the asset collection supports adding content.

        if assetCollection == nil || assetCollection.canPerform(.addContent) {
            navigationItem.rightBarButtonItem = addButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCachedAssets()
        
    }
    
    fileprivate func resetCacheAssets() {
        imageManager.stopCachingImagesForAllAssets()
        perviousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        guard isViewLoaded && view.window != nil else {return}
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        let delta = abs(preheatRect.midY - perviousPreheatRect.midY)
        
        guard delta > view.bounds.height / 3 else {return}
        
        let (addedRects, removedRect) = differencesBetweenRects(perviousPreheatRect, preheatRect)
        
        let addedAssets = addedRects
            .compactMap { rect in collectionView!.indexPathForItem(at: rect.origin) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRect
            .compactMap { rect in collectionView!.indexPathForItem(at: rect.origin) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        imageManager.startCachingImages(for: addedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        perviousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old:CGRect, _ new:CGRect) -> (add:[CGRect], remove:[CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.y, y: old.maxY, width: new.width, height: new.maxY - old.maxY)]
            }
            
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY, width: new.width, height: old.minY - new.minY)]
            }
            
            var remove = [CGRect()]
            if new.maxY < old.maxY {
                remove += [CGRect(x: new.origin.x, y: new.maxY, width: new.width, height: old.maxY  - new.maxY)]
            }
            
            if old.minY < new.minY {
                remove += [CGRect(x: new.origin.x, y: old.minY, width: new.width, height: new.midY - old.minY)]
            }
            return (added, remove)
        } else {
            return ([new], [old])
        }
    }
    
}

extension AssetGridViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as? GridViewCell else {fatalError("Unexpected cell in collection view") }
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { (image, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        }
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
}


extension AssetGridViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
        
        DispatchQueue.main.sync {
            fetchResult = changes.fetchResultAfterChanges
            
            if changes.hasIncrementalChanges {
                guard let collectionView = self.collectionView else { fatalError() }
                
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0)}))
                    }
                    
                    if let instance = changes.insertedIndexes, !instance.isEmpty {
                        collectionView.insertItems(at: instance.map({ IndexPath(item: $0, section: 0)}))
                    }
                    
                    changes.enumerateMoves({ (forIndex, toIndex) in
                        collectionView.moveItem(at: IndexPath(item: forIndex, section: 0), to: IndexPath(item: toIndex, section: 0))
                    })
                })
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0)}))
                }
                
            } else {
                collectionView.reloadData()
            }
            
            resetCacheAssets()
        }
    }
    
    
}


extension AssetGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width / 4 - 1
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
