//
//  PhotosViewModels.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

protocol PhotosViewModelsDelegate {
    func libraryDidChange(changes: PHChange)
}

open class PhotosViewModels: UIViewController {

    var imageManager = PHCachingImageManager()
    var fetchResult: PHFetchResult<PHAsset>!
    var delegate: PhotosViewModelsDelegate?
    var targetSize: CGSize {
        let w = UIScreen.main.bounds.width / 4 - 1
        let t = w * UIScreen.main.scale
        return CGSize(width: t, height: t)
    }
    
    open override func loadView() {
        super.loadView()
        PHPhotoLibrary.shared().register(self)
        if let collection = PHPhotoLibrary.shared().findAlbum(albumName: "FLIM-I") {
            let option = PHFetchOptions()
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.fetchResult = PHAsset.fetchAssets(in: collection, options: option)
        } else {
            self.fetchResult = PHFetchResult<PHAsset>()
        }
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }

}

extension PhotosViewModels: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.libraryDidChange(changes: changeInstance)
    }
    
}
