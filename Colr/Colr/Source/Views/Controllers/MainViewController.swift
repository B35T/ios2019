//
//  ViewController.swift
//  Colr
//
//  Created by chaloemphong on 19/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class MainViewController: PhotosViewController {

    @IBOutlet open weak var closeBtn: CloseButton!
    @IBOutlet open weak var nextBtn: NextButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collection.reloadData()
        let c = CloseButton()
        c.add(view: self.view,.init(x: 25, y: self.view.frame.height.minus(i: 65)))
        c.animatedHidden()
        self.closeBtn = c
        
        let n = NextButton()
        n.add(view: self.view, self.view.minusSize(135, 65))
        n.animatedHidden()
        self.nextBtn = n
        
        self.closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(editor), for: .touchUpInside)
        
        
    }

    @objc internal func close() {
        resetCachedAssets()
        self.animated(action: false)
        self.closeBtn.animatedHidden()
        self.nextBtn.animatedHidden()
    }
    
    @objc internal func editor() {
        let vc = EditorViewController()
        self.show(vc, sender: nil)
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = self.c - 1 - indexPath.item
        imageManager.requestImage(for: self.fetchResult.object(at: i), targetSize: CGSize(width: 1000, height: 1000), contentMode: PHImageContentMode.aspectFill, options: self.requestOption) { (image, any) in
            if let img = image {
                self.imageview.image = img
            }
        }
        
        self.closeBtn.animatedHidden(action: false, time: 0.3)
        self.nextBtn.animatedHidden(action: false, time: 0.3)
        self.animated(action: true)
        self.collection.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

