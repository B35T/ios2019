//
//  ViewController.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class StartViewController: PhotosAsset {

    @IBOutlet weak var cover: Cover!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var editorView: EditorViewControllers!
    
    override func loadView() {
        super.loadView()
        
     
        let cover = Cover(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 100 * 65))
        self.cover = cover
        self.view.insertSubview(self.cover, at: 0)
        
        let blur = UIBlurEffect.init(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        self.blurView = blurView
        self.blurView.frame = view.frame
        self.blurView.alpha = 0
        self.view.insertSubview(blurView, at: 1)
        
        self.view.insertSubview(collectionView, at: 2)
        
        self.editorView = self.storyboard?.instantiateViewController(withIdentifier: "Editor") as? EditorViewControllers
        
    }
    
    @objc internal func closeAction() {
        self.cover.animation(point: .init(x: 0, y: 0), duration: 0.4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cover.image = UIImage(named: "cover.jpg")
    }
}

extension StartViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset.y / view.frame.height
        self.blurView.alpha = p * 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.editorView.asset = self.fetchResults.object(at: indexPath.item)
            self.editorView.view.alpha = 1
            DisayaProfile.shared.defualt()
            self.show(self.editorView, sender: nil)
        }
    }
}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

