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
    func photosResult(image: UIImage?, index:Int?)
}

class PhotosViewController: UICollectionViewController {
    
    var imageManager = PHCachingImageManager()
    var fetchResults: PHFetchResult<PHAsset>!
    let cells = "PhotosCell"
    var targetSize: CGSize {
        let w = UIScreen.main.bounds.width / 4 - 1
        let t = w * UIScreen.main.scale
        return CGSize(width: t, height: t)
    }
    var delegate: PhotosViewCollectionDelegate?
    
    var countimage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.shared().register(self)

        let smart = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let cameraRoll = smart.object(at: 0)
        
        let option = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        self.fetchResults = PHAsset.fetchAssets(in: cameraRoll, options: option)
        collectionView.register(UINib(nibName: cells, bundle: nil), forCellWithReuseIdentifier: cells)
        self.countimage = self.fetchResults.count
    }
    
    
    public func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension PhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let i = self.countimage - indexPath.item
        let asset = self.fetchResults.object(at: i - 1)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cells, for: indexPath) as! PhotosCell
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imageview.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let w = UIScreen.main.bounds.width
        let s = w * UIScreen.main.scale
        let i = self.countimage - indexPath.item
        let asset = self.fetchResults.object(at: i - 1)
        
        self.collectionView.scrollToItem(at: IndexPath(item: indexPath.item, section: 0), at: .top, animated: true)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: s, height: s), contentMode: .aspectFill, options: nil) { (image, _) in
            self.delegate?.photosResult(image: image, index: i - 1)
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
        
        guard let changes = changeInstance.changeDetails(for: fetchResults)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResults = changes.fetchResultAfterChanges
            self.countimage = fetchResults.count
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                guard let collectionView = self.collectionView else { fatalError() }
                // Handle removals, insertions, and moves in a batch update.
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
                // items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
}

extension Date {
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
}
//
