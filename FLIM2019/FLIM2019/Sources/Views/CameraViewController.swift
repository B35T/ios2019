//
//  CameraViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class CameraViewController: CameraViewModels {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgTop: UIImageView!
    @IBOutlet weak var bgBottom: UIImageView!
    @IBOutlet weak var viewFinderFrame: UIImageView!
    @IBOutlet weak var viewFinder: UIImageView!
    @IBOutlet weak var logoView:UIImageView!
    @IBOutlet weak var AFBtn: UIButton!
    @IBOutlet weak var FlashBtn: UIButton!
    @IBOutlet weak var shutterBtn: UIButton!
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var filmView:UIView!
    
    // in bg
    
    @IBOutlet weak var loadNewFilmBtn: UIButton!
    @IBOutlet weak var sendToDevelop: UIButton!
    @IBOutlet weak var toPhotos: UIButton!
    
    
    var isFullView:(isFull: Bool,rect: CGRect) = (false,.zero)
    
    var isLoad = false
    var isAF = false
    var isFlash = false
    
    override func loadView() {
        super.loadView()
        
        let r = self.view.frame
        
        let bgTop = UIImageView()
        self.bgTop = bgTop
        self.bgTop.frame = .init(x: r.width.persent(65), y: 0, width: r.width.persent(35), height: r.height)
        self.view.addSubview(self.bgTop)
        
        let loadNewFilmBtn = UIButton()
        self.loadNewFilmBtn = loadNewFilmBtn
        self.loadNewFilmBtn.frame = .init(x: r.width.persent(25), y: r.height.persent(2), width: 40, height: 105)
        self.view.addSubview(self.loadNewFilmBtn)
        
        let sendToDevelop = UIButton()
        self.sendToDevelop = sendToDevelop
        self.sendToDevelop.frame = .init(x: r.width.persent(40), y: r.height.persent(2), width: 40, height: 105)
        self.view.addSubview(self.sendToDevelop)
        
        let toPhotos = UIButton()
        self.toPhotos = toPhotos
        self.toPhotos.frame = .init(x: r.width.persent(40), y: r.height.persent(82), width: 40, height: 105)
        self.view.addSubview(self.toPhotos)
        
        let bgBottom = UIImageView()
        self.bgBottom = bgBottom
        self.bgBottom.frame = .init(x: 0, y: 0, width: r.width.persent(65), height: r.height)
        self.view.addSubview(self.bgBottom)
        
        let AFBtn = UIButton()
        self.AFBtn = AFBtn
        self.AFBtn.frame = .init(x: bgTop.center.x - 25, y: r.height.persent(30), width: 50, height: 50)
        self.view.addSubview(self.AFBtn)
        
        let flashBtn = UIButton()
        self.FlashBtn = flashBtn
        self.FlashBtn.frame = .init(x: bgTop.center.x - 25, y: AFBtn.frame.maxY + 20, width: 50, height: 50)
        self.view.addSubview(self.FlashBtn)
        
        let shutterBtn = UIButton()
        self.shutterBtn = shutterBtn
        self.shutterBtn.frame = .init(x: bgTop.center.x - (r.width.persent(25) / 2) , y: r.height.persent(82), width: r.width.persent(25), height: r.width.persent(25))
        self.view.addSubview(self.shutterBtn)
        
        let logoView = UIImageView()
        self.logoView = logoView
        self.logoView.frame = .init(x: r.width.persent(3), y: r.height.persent(4), width: 51, height: 111)
        self.bgBottom.addSubview(self.logoView)
        
        let tutorialBtn = UIButton()
        self.tutorialBtn = tutorialBtn
        self.tutorialBtn.frame = .init(x: logoView.center.x - 25, y: logoView.frame.maxY + 20, width: 50, height: 50)
        self.bgBottom.addSubview(self.tutorialBtn)
        
        self.collectionView.frame = .init(x: r.width.persent(3.5), y: r.height.persent(20), width: r.width.persent(60), height: r.height.persent(60))
        self.collectionView.layer.cornerRadius = 6
        self.collectionView.backgroundColor = film
        
        let viewFiderFrame = UIImageView()
        self.viewFinderFrame = viewFiderFrame
        self.viewFinderFrame.frame = .init(x: r.width.persent(65), y: r.height.persent(5), width: r.width.persent(35), height: r.width.persent(35))
        self.view.addSubview(self.viewFinderFrame)
        
        let vf = self.viewFinderFrame.frame
        
        let viewFider = UIImageView()
        self.viewFinder = viewFider
        self.viewFinder.frame.size = .init(width: vf.width.persent(50), height: vf.width.persent(60))
        self.viewFinder.center = self.viewFinderFrame.center
        self.viewFinder.contentMode = .scaleAspectFill
        self.viewFinder.layer.cornerRadius = 6
        self.viewFinder.clipsToBounds = true
        self.isFullView.rect = self.viewFinder.frame
        self.view.addSubview(self.viewFinder)
        
        let loadBtn = UIButton()
        self.loadBtn = loadBtn
        self.loadBtn.frame = .init(x: 10, y: r.height.persent(82), width: 86, height: 86)
        self.view.addSubview(self.loadBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = bg
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.bgTop.image = UIImage(named: "bgtop.png")
        self.bgBottom.image = UIImage(named: "skin.png")
        self.viewFinderFrame.image = UIImage(named: "ViewFider.png")
        self.viewFinder.image = UIImage(named: "IMG_0327.JPG")
        self.AFBtn.setBackgroundImage(UIImage(named: "AF.png"), for: .normal)
        self.FlashBtn.setBackgroundImage(UIImage(named: "Flash.png"), for: .normal)
        self.shutterBtn.setBackgroundImage(UIImage(named: "Shutter.png"), for: .normal)
        self.logoView.image = UIImage(named: "Logo.png")
        self.tutorialBtn.setBackgroundImage(UIImage(named: "tutorial_icon.png"), for: .normal)
        self.loadBtn.setBackgroundImage(UIImage(named: "LoadOff.png"), for: .normal)
        
        self.loadNewFilmBtn.setBackgroundImage(UIImage(named: "AddNew.png"), for: .normal)
        self.sendToDevelop.setBackgroundImage(UIImage(named: "Send.png"), for: .normal)
        self.toPhotos.setBackgroundImage(UIImage(named: "Photos.png"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fullViewAction(_:)))
        self.viewFinder.addGestureRecognizer(tap)
        self.viewFinder.isUserInteractionEnabled = true
        
        self.AFBtn.addTarget(self, action: #selector(AFAction(_:)), for: .touchUpInside)
        self.FlashBtn.addTarget(self, action: #selector(flashAction(_:)), for: .touchUpInside)
        self.loadBtn.addTarget(self, action: #selector(loadAction(_:)), for: .touchUpInside)
        self.shutterBtn.addTarget(self, action: #selector(shutterAction), for: .touchUpInside)
    }
    
    @objc internal func fullViewAction(_ sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if let view = sender.view {
                if self.isFullView.isFull {
                    view.frame = self.isFullView.rect
                } else {
                    view.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 1.3333)
                }
                
                self.isFullView.isFull = !self.isFullView.isFull
            }
            
        }
    }
    
    @objc internal func shutterAction() {
        UIView.animate(withDuration: 0.3) {
            if self.isLoad {
                self.bgBottom.frame.origin.y = 0
                self.loadBtn.transform = .init(rotationAngle: .pi / 180 * 0)
            }
            self.isLoad = false
        }
        
    }
    
    @objc internal func loadAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            if self.isLoad {
                self.bgBottom.frame.origin.y = 0
                sender.transform = .init(rotationAngle: .pi / 180 * 0)
            } else {
                self.bgBottom.frame.origin.y = -self.view.frame.height
                sender.transform = .init(rotationAngle: .pi / 180 * 90)
            }
            self.isLoad = !self.isLoad
        }
        
    }
    
    @objc internal func AFAction(_ sender: UIButton) {
        if self.isAF {
            sender.setBackgroundImage(UIImage(named: "AF.png"), for: .normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "AF_on.png"), for: .normal)
        }
        
        self.isAF = !self.isAF
    }
    
    @objc internal func flashAction(_ sender: UIButton) {
        if self.isFlash {
            sender.setBackgroundImage(UIImage(named: "Flash.png"), for: .normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Flash_on.png"), for: .normal)
        }
        
        self.isFlash = !self.isFlash
    }
}


extension CameraViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmPreviewCell", for: indexPath) as! FilmPreviewCell
        cell.imageview.image = UIImage(named: "IMG_0327.JPG")?.ColorInvertFX
        cell.imageview.alpha = 0.3
//        cell.backgroundColor = .clear
//        cell.layer.compositingFilter = "colorInvert"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.width.persent(40), height: self.view.frame.width.persent(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}


extension UIImage {
    var ColorInvertFX:UIImage {
        let ciimage = CIImage.init(image: self)
        let colorInvert = ciimage?.applyingFilter("CIColorInvert", parameters: [:])
        return UIImage.init(ciImage: colorInvert!)
    }
}
