//
//  SaveOptionViewController.swift
//  Disaya
//
//  Created by chaloemphong on 31/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol SaveOptionViewControllerDelegate {
    func saveOptionClose(viewController: SaveOptionViewController)
    func saveMax(viewController: SaveOptionViewController)
    func saveNormal(viewController: SaveOptionViewController)
}

class SaveOptionViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var MaxQualityBtn: UIButton!
    @IBOutlet weak var NormalQualityBtn:UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var activity:UIActivityIndicatorView!
    
    var delegate: SaveOptionViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        
        let background = UIView()
        self.background = background
        self.background.frame = .init(x: 0, y: view.frame.height - 210, width: view.frame.width, height: 210)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.frame.width, height: 250)
        self.background.addSubview(blurView)
        
        let MaxQualityBtn = UIButton()
        self.MaxQualityBtn = MaxQualityBtn
        self.MaxQualityBtn.frame = .init(x: 15, y: 15, width: view.frame.width - 30, height: 55)
        self.MaxQualityBtn.setTitle("Max Quality", for: .normal)
        self.MaxQualityBtn.backgroundColor = yellow
        self.MaxQualityBtn.setTitleColor(.black, for: .normal)
        self.MaxQualityBtn.layer.cornerRadius = 4
        
        let NormalQualityBtn = UIButton()
        self.NormalQualityBtn = NormalQualityBtn
        self.NormalQualityBtn.frame = .init(x: 15, y: 80, width: view.frame.width - 30, height: 55)
        self.NormalQualityBtn.setTitle("Normal Quality", for: .normal)
        self.NormalQualityBtn.backgroundColor = yellow
        self.NormalQualityBtn.setTitleColor(.black, for: .normal)
        self.NormalQualityBtn.layer.cornerRadius = 4
        
        let closeBtn = UIButton()
        self.closeBtn = closeBtn
        self.closeBtn.frame = .init(x: 0, y: 145, width: view.frame.width, height: 55)
        self.closeBtn.setTitle("Close", for: .normal)
        
        self.background.addSubview(self.MaxQualityBtn)
        self.background.addSubview(self.NormalQualityBtn)
        self.background.addSubview(self.closeBtn)
        
        self.view.addSubview(self.background)
        
        let activity = UIActivityIndicatorView()
        self.activity = activity
        self.activity.frame.size = self.view.frame.size
        self.activity.center = self.view.center
        self.activity.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.activity.isHidden = true
        self.view.addSubview(self.activity)
        
        self.view.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.MaxQualityBtn.addTarget(self, action: #selector(self.maxQualityAction), for: .touchUpInside)
        self.NormalQualityBtn.addTarget(self, action: #selector(self.nornalQualityAction), for: .touchUpInside)
        self.closeBtn.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        
        self.MaxQualityBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.NormalQualityBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }

    @objc internal func maxQualityAction() {
        self.activity.startAnimating()
        self.activity.isHidden = false
        self.delegate?.saveMax(viewController: self)
    }
    
    @objc internal func nornalQualityAction() {
        self.activity.startAnimating()
        self.activity.isHidden = false
        self.delegate?.saveNormal(viewController: self)
    }
    
    @objc internal func closeAction() {
        self.delegate?.saveOptionClose(viewController: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
