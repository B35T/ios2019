//
//  PhotosViewController.swift
//  Colr
//
//  Created by chaloemphong on 20/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
import UIKit
import Photos

extension CGFloat {
    public func persen(p:CGFloat) -> CGFloat {
        let c = self / 100 * p
        return c
    }
    
    var x:CGPoint {
        return CGPoint(x: self, y: 0)
    }
    
    var y:CGPoint {
        return CGPoint(x: 0, y: self)
    }
    
    var w:CGSize {
        return CGSize(width: self, height: 0)
    }
    
    var h:CGSize {
        return CGSize(width: 0, height: self)
    }
    
    func minus(i:CGFloat) -> CGFloat {
        return self - i
    }
}

extension UIView {
    func minusSize(_ x:CGFloat = 0.0,_ y:CGFloat = 0.0) -> CGPoint {
        let f = self.frame
        return CGPoint(x: f.width - x, y: f.height - y)
    }
}

class PhotosViewController: UIViewController {
    
    
    @IBOutlet open weak var collection: UICollectionView!
    @IBOutlet open weak var imageview: UIImageView!
    
    
    var imageManager:PHCachingImageManager!
    var requestOption:PHImageRequestOptions!
    var fetchOption:PHFetchOptions!
    var fetchResult:PHFetchResult<PHAsset>!
    
    var c:Int = 0
    
    open override func loadView() {
        super.loadView()
        
        let collec = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collec.translatesAutoresizingMaskIntoConstraints = false
        
        self.collection = collec
        self.collection.frame = self.view.frame
        self.view.addSubview(self.collection)
        
        
        let imageview = UIImageView(frame: .zero)
        self.imageview = imageview
        self.imageview.frame.size.width = self.view.frame.width
        self.imageview.contentMode = .scaleAspectFit
        self.imageview.clipsToBounds = true
        self.view.addSubview(self.imageview)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.imageManager = PHCachingImageManager()
        self.requestOption = PHImageRequestOptions()
        self.requestOption.isSynchronous = true
        self.fetchOption = PHFetchOptions()
        
        self.collection.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        self.collection.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "photos")
        self.collection.delegate = self
        self.collection.dataSource = self
        
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
    }
    
    func animated(action:Bool) {
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        
        if action {
            self.collection.frame.origin = self.view.frame.height.persen(p: 65).y
            self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height.persen(p: 35))
            layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height.persen(p: 64.9))
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 0)
                self.collection.frame.origin = .zero
                self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height)
            })
            layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
        }
    }
    
    var count:Int {
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: self.fetchOption)
        self.c = self.fetchResult.count
        return c
    }
    
    
    
    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    func cache(index:Int) {
        guard isViewLoaded && view.window != nil else { return }
        
        imageManager.startCachingImages(for: [fetchResult.object(at: index)], targetSize: .init(width: 100, height: 100), contentMode: .aspectFill, options: nil)
        
    }
    
    func stopCache(index:Int) {
        guard isViewLoaded && view.window != nil else { return }
        imageManager.stopCachingImages(for: [fetchResult.object(at: index)], targetSize: .init(width: 100, height: 100), contentMode: .aspectFill, options: nil)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotosCell
        
        let i = (self.c - 1) - indexPath.item
        let asset = fetchResult.object(at: i)

        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: .init(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // UIKit may have recycled this cell by the handler's activation time.
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
                self.cache(index: i)
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let i = (self.c - 1) - indexPath.item
        self.stopCache(index: i)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let h = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderReusableView
        h.HeaderLabel.text = "Photos"
        //        h.frame = .init(origin: .zero, size: .init(width: self.view.frame.width, height: 70))
        return h
        
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.bounds.width / 4 - 1
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: self.view.frame.width, height: 70)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 80)
    }
    
}

extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                guard let collection = self.collection else { fatalError() }
                // Handle removals, insertions, and moves in a batch update.
                collection.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collection.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collection.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collection.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
                // items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collection.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                self.collection.reloadData()
            }
            resetCachedAssets()
        }
    }
}
