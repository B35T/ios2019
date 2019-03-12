//
//  CropingViewController.swift
//  Colr
//
//  Created by chaloemphong on 9/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos


class CropViewController: CropImageViewController {
    
    var asset: PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHImageManager.default().requestImage(for: asset, targetSize: .init(width: 1000, height: 1000), contentMode: .aspectFit, options: nil) { (img, _) in
            self.image = img
        }
        
        let closeBtn = CloseButton()
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: view.h - 80))
        
        self.view.backgroundColor = .black
        self.view.isUserInteractionEnabled = true
    }
    
    @objc internal func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
