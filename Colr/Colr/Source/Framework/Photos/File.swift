//
//  PhotosViewController.swift
//  Colr
//
//  Created by chaloemphong on 20/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
/*
import UIKit
import Photos

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

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
    @IBOutlet open weak var closeBtn: CloseButton!
    @IBOutlet open weak var nextBtn: NextButton!
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    var availableWidth: CGFloat = 0
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
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
        
        let c = CloseButton()
        c.add(view: self.view,.init(x: 25, y: self.view.frame.height.minus(i: 65)))
        c.animatedHidden()
        self.closeBtn = c
        
        let n = NextButton()
        n.add(view: self.view, self.view.minusSize(135, 65))
        n.animatedHidden()
        self.nextBtn = n
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = .black
        
        self.resetCachedAssets()
        
        PHPhotoLibrary.shared().register(self)
        
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
        
        
        self.collection.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        self.collection.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "photos")
        self.collection.delegate = self
        self.collection.dataSource = self
        
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
        
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        thumbnailSize = CGSize(width: 100, height: 100)
        
        
    }
    
    func animated(action:Bool) {
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        
        UIView.animate(withDuration: 0.3) {
            if action {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height.persen(p: 64.9))
                self.collection.frame.origin = self.view.frame.height.persen(p: 65).y
                self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height.persen(p: 35))
                layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 0)
            } else {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 0)
                self.collection.frame.origin = .zero
                self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height)
                layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
            }
        }
    }
    
    // MARK: Asset Caching
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    /// - Tag: UpdateAssets
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The window you prepare ahead of time is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collection.contentOffset, size: collection.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start and stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collection.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collection.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        // Store the computed rectangle for future comparison.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotosCell
        
        //        let i = (self.c - 1) - indexPath.item
        
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // UIKit may have recycled this cell by the handler's activation time.
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let h = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderReusableView
        h.HeaderLabel.text = "Photos"
        
        return h
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotosCell
        cell.imageview.image = nil
        
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = fetchResult.object(at: indexPath.item)
        
        //        let i = self.c - 1 - indexPath.item
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // UIKit may have recycled this cell by the handler's activation time.
            // Set the cell's thumbnail image only if it's still showing the same asset.
            self.imageview.image = image
        })
        
        
        self.closeBtn.animatedHidden(action: false)
        self.nextBtn.animatedHidden(action: false)
        self.animated(action: true)
        self.collection.scrollToItem(at: indexPath, at: .top, animated: true)
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
                guard let collectionView = self.collection else { fatalError() }
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
                collection.reloadData()
            }
            resetCachedAssets()
        }
    }
    
    
}
 */
