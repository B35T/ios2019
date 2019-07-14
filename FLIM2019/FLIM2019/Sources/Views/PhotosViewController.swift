//
//  PhotosViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: PhotosViewModels {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.delegate = self
        
        let headerBar = UIView()
        self.headerBar = headerBar
        self.headerBar.frame = .init(x: 0, y: 0, width: view.frame.width, height: 70)
        self.headerBar.addSubview(self.backBtn)
        self.headerBar.addSubview(self.titleLabel)
        self.view.addSubview(self.headerBar)
        
        let imageView = UIImageView()
        self.imageView = imageView
        self.imageView.frame = .init(x: 0, y: 70, width: view.frame.width, height: 0)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.view.addSubview(self.imageView)

      
        self.view.addSubview(backBtn)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.backgroundColor = .black
        self.collectionView.frame = .init(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70)
        
        self.headerBar.backgroundColor = .black
        self.backBtn.frame = .init(x: 5, y: 30, width: 70, height: 30)
        self.titleLabel.frame = .init(x: view.frame.width - 95, y: 30, width: 90, height: 40)
        
        self.backBtn.setTitle("", for: .normal)
        self.backBtn.setBackgroundImage(UIImage(named: "back.png"), for: .normal)
        self.backBtn.layer.compositingFilter = "sreeenBlendMode"
        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc internal func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: PhotosViewModelsDelegate {
    func libraryDidChange(changes: PHChange) {
        guard let changes = changes.changeDetails(for: self.fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            self.fetchResult = changes.fetchResultAfterChanges
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

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.imageView.frame.size.height = self.view.frame.width
            self.collectionView.frame.origin.y = self.imageView.frame.height + 70
            self.collectionView.frame.size.height = self.view.frame.height - self.imageView.frame.maxY
            let asset = self.fetchResult.object(at: indexPath.item)
            self.imageManager.requestImage(for: asset, targetSize: .init(width: 1000, height: 1000), contentMode: .aspectFit, options: nil, resultHandler: { (image, _) in
                self.imageView.image = image
            })
        }
        
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "previewimage", for: indexPath) as! imagepreviewCell
        cell.layer.cornerRadius = 2
        cell.imageview.contentMode = .scaleAspectFill
        let asset = self.fetchResult.object(at: indexPath.item)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imageview.image = image
        }

        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width / 4 - 1
        return .init(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 0)
    }
}
