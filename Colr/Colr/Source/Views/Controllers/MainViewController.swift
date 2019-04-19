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
    
    var x: CGFloat {
        return self.frame.origin.x
    }
    
    var y: CGFloat {
        return self.frame.origin.y
    }
}

class MainViewController: PhotosViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var colrProBtn: UIBarButtonItem!
    @IBOutlet weak var CloseBtn: CloseButton!
    @IBOutlet weak var NextBtn: NextButton!
    var viewEdit:EditorViewController!
    
    var index:Int? = nil
    
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
        
        let nextBtn = NextButton()
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextBtn.alpha = 0
        nextBtn.add(view: view, .init(x: view.w.minus(n: 125), y: view.h.minus(n: 65)))
        self.NextBtn = nextBtn
        
        self.navigationItem.rightBarButtonItem = self.colrProBtn
//        self.colrProBtn.tintColor = .white
        self.colrProBtn.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)], for: .normal)
        
        self.delegate = self
        
        self.viewEdit = self.storyboard?.instantiateViewController(withIdentifier: "Editor") as? EditorViewController
        viewEdit.view.alpha = 0
        self.view.addSubview(viewEdit.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }

    override var prefersStatusBarHidden: Bool {
        return self.statusBarHidden
    }
    
    @objc internal func closeAction() {
        self.CloseBtn.animatedHidden(action: true)
        self.NextBtn.animatedHidden(action: true)
        self.animated(action: false)
    }
    
    @objc internal func nextAction() {
//        self.performSegue(withIdentifier: "Editor", sender: nil)
        guard let index = index else {return}
        UIView.animate(withDuration: 0.3) {
            let asset = self.fetchResults.object(at: index)
            let ss:CGFloat = 100//UIScreen.main.bounds.width // * UIScreen.main.scale
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: ss, height: ss), contentMode: .aspectFit, options: nil) { (image, _) in
                self.viewEdit.original = image
            }
            
            self.viewEdit.asset = asset
            self.viewEdit.view.alpha = 1
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let editor = segue.destination as? EditorViewController else {return}
//        if let i = self.index {
//            editor.asset = self.fetchResults.object(at: i)
//        }
        
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
    func photosResult(image: UIImage?, index: Int?) {
        self.imageView.image = image
        self.index = index
        self.CloseBtn.animatedHidden(action: false)
        self.NextBtn.animatedHidden(action: false)
        
        self.animated(action: true)
    }
}
