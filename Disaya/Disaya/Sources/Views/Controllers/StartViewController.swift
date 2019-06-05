//
//  ViewController.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class StartViewController: PhotosAsset {

    @IBOutlet weak var cover: Cover!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    var editorView: EditorViewControllers!
    
    override func loadView() {
        super.loadView()
        
        let cover = Cover(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 100 * 65))
        self.cover = cover
        self.view.insertSubview(self.cover, at: 0)
        
        let blur = UIBlurEffect.init(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        self.blurView = blurView
        self.blurView.frame = view.frame
        self.blurView.alpha = 0
        self.view.insertSubview(blurView, at: 1)
        
        self.view.insertSubview(collectionView, at: 2)
        
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        self.titleLabel.frame.size = .init(width: 250, height: 30)
        self.titleLabel.center.x = self.view.center.x
        self.titleLabel.frame.origin.y = self.cover.frame.maxY - 10
        self.titleLabel.layer.cornerRadius = 15
        self.titleLabel.clipsToBounds = true
        self.titleLabel.textColor = black
        self.titleLabel.backgroundColor = .white
        self.titleLabel.text = "TY img from unsplash.com/@damian_ivanovv"
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
        self.titleLabel.textAlignment = .center
        
        self.view.insertSubview(self.titleLabel, at: 1)
        
        self.editorView = self.storyboard?.instantiateViewController(withIdentifier: "Editor") as? EditorViewControllers
        
        if UserDefaults.standard.value(forKey: "first_time") != nil {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized: break
            default:
                let setting = UIButton()
                setting.frame.size = .init(width: 250, height: 50)
                setting.frame.origin.y = self.view.frame.maxY - 100
                setting.center.x = self.view.center.x
                setting.backgroundColor = .white
                setting.setTitle("Allow access to Photos", for: .normal)
                setting.setTitleColor(blue, for: .normal)
                setting.titleLabel?.font = .boldSystemFont(ofSize: 11)
                setting.layer.cornerRadius = 4
                setting.clipsToBounds = true
                setting.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
                self.view.addSubview(setting)
            }
        }
       
        UserDefaults.standard.set(true, forKey: "first_time")
    }
    
    @objc internal func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc internal func closeAction() {
        self.cover.animation(point: .init(x: 0, y: 0), duration: 0.4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cover.image = UIImage(named: "cover2.jpg")
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

