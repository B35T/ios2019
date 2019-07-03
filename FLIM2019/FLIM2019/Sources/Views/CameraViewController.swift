//
//  CameraViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class CameraViewController: CameraViewModels {

    @IBOutlet weak var bgTop: UIImageView!
    @IBOutlet weak var bgBottom: UIImageView!
    @IBOutlet weak var viewFiderFrame: UIImageView!
    @IBOutlet weak var viewFider: UIImageView!
    @IBOutlet weak var logoView:UIImageView!
    @IBOutlet weak var AFBtn: UIButton!
    @IBOutlet weak var FlashBtn: UIButton!
    @IBOutlet weak var shutterBtn: UIButton!
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var loadBtn: UIButton!
    
    
    var save:CGRect = .zero
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
        
        let bgBottom = UIImageView()
        self.bgBottom = bgBottom
        self.bgBottom.frame = .init(x: 0, y: 0, width: r.width.persent(65), height: r.height)
        self.view.addSubview(self.bgBottom)
        
        let viewFiderFrame = UIImageView()
        self.viewFiderFrame = viewFiderFrame
        self.viewFiderFrame.frame = .init(x: r.width.persent(65), y: r.height.persent(5), width: r.width.persent(35), height: r.width.persent(35))
        self.view.addSubview(self.viewFiderFrame)
        
        let vf = self.viewFiderFrame.frame
        
        let viewFider = UIImageView()
        self.viewFider = viewFider
        self.viewFider.frame.size = .init(width: vf.width.persent(50), height: vf.width.persent(60))
        self.viewFider.center = self.viewFiderFrame.center
        self.viewFider.contentMode = .scaleAspectFill
        self.viewFider.layer.cornerRadius = 6
        self.viewFider.clipsToBounds = true
        self.save = self.viewFider.frame
        self.view.addSubview(self.viewFider)
        
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
        self.view.addSubview(self.logoView)
        
        let tutorialBtn = UIButton()
        self.tutorialBtn = tutorialBtn
        self.tutorialBtn.frame = .init(x: logoView.center.x - 25, y: logoView.frame.maxY + 20, width: 50, height: 50)
        self.view.addSubview(self.tutorialBtn)
        
        let loadBtn = UIButton()
        self.loadBtn = loadBtn
        self.loadBtn.frame = .init(x: 10, y: r.height.persent(82), width: 86, height: 86)
        self.view.addSubview(self.loadBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgTop.image = UIImage(named: "bgtop.png")
        self.bgBottom.image = UIImage(named: "skin.png")
        self.viewFiderFrame.image = UIImage(named: "ViewFider.png")
        self.viewFider.image = UIImage(named: "IMG_0327.JPG")
        self.AFBtn.setBackgroundImage(UIImage(named: "AF.png"), for: .normal)
        self.FlashBtn.setBackgroundImage(UIImage(named: "Flash.png"), for: .normal)
        self.shutterBtn.setBackgroundImage(UIImage(named: "Shutter.png"), for: .normal)
        self.logoView.image = UIImage(named: "Logo.png")
        self.tutorialBtn.setBackgroundImage(UIImage(named: "tutorial_icon.png"), for: .normal)
        self.loadBtn.setBackgroundImage(UIImage(named: "LoadOff.png"), for: .normal)
        
        self.AFBtn.addTarget(self, action: #selector(AFAction(_:)), for: .touchUpInside)
        self.FlashBtn.addTarget(self, action: #selector(flashAction(_:)), for: .touchUpInside)
        self.loadBtn.addTarget(self, action: #selector(loadAction(_:)), for: .touchUpInside)
    }
    
    @objc internal func loadAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            if self.isLoad {
                sender.transform = .init(rotationAngle: .pi / 180 * 0)
            } else {
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
