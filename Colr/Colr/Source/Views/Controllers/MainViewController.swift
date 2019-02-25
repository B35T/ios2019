//
//  ViewController.swift
//  Colr
//
//  Created by chaloemphong on 19/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

extension CGFloat {
    func persen(p: CGFloat) -> CGFloat {
        return self / 100 * p
    }
    
    func minus(n: CGFloat) -> CGFloat {
        return self - n
    }
}

extension UIView {
    var w: CGFloat {
        return self.frame.width
    }
    
    var h: CGFloat {
        return self.frame.height
    }
    
    var size: CGSize {
        return self.frame.size
    }
}

class MainViewController: PhotosViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var CloseBtn: CloseButton!
    @IBOutlet weak var NextBtn: NextButton!
    
    var statusBarHidden:Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .black
        
        let imageView = UIImageView(frame: .zero)
        imageView.frame.size.width = self.view.w
        self.imageView = imageView
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageView)
        
        let closeBtn = CloseButton()
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.alpha = 0
        closeBtn.add(view: view, .init(x: 15, y: view.h.minus(n: 65)))
        self.CloseBtn = closeBtn
        self.view.addSubview(CloseBtn)
        
        let nextBtn = NextButton()
        nextBtn.alpha = 0
        nextBtn.add(view: view, .init(x: view.w.minus(n: 125), y: view.h.minus(n: 65)))
        self.NextBtn = nextBtn
        self.view.addSubview(self.NextBtn)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        
        self.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    @objc internal func closeAction() {
        self.CloseBtn.animatedHidden(action: true)
        self.NextBtn.animatedHidden(action: true)
        self.animated(action: false)
    }

    fileprivate func showPreview(action: Bool) {
        UIView.animate(withDuration: 0.3) {
            if action {
                self.imageView.frame = .init(x: 0, y: 0, width: self.view.w, height: self.view.h.persen(p: 69.8))
            } else {
                
                self.imageView.frame = .init(x: 0, y: 0, width: self.view.w, height: 0)
            }
        }
    }
    
    fileprivate func animated(action: Bool) {
        if action {
            self.collectionView.frame = .init(x: 0, y: self.view.h.persen(p: 70), width: self.view.w, height: self.view.h.persen(p: 30))
            self.statusBarHidden = true
            self.showPreview(action: true)
        } else {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.frame = .init(x: 0, y: 0, width: self.view.w, height: self.view.h)
            }
            self.statusBarHidden = false
            self.showPreview(action: false)
        }
        
        self.hiddenNavi = action
    }
    
    fileprivate var hiddenNavi: Bool = false {
        didSet {
            self.navigationController?.setNavigationBarHidden(self.hiddenNavi, animated: true)
        }
    }
}

extension MainViewController: PhotosViewCollectionDelegate {
    func photosResult(image: UIImage?) {
        self.imageView.image = image
        
        self.CloseBtn.animatedHidden(action: false)
        self.NextBtn.animatedHidden(action: false)
        
        self.animated(action: true)
    }
}
