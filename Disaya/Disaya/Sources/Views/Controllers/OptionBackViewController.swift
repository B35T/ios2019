//
//  OptionBackViewController.swift
//  Disaya
//
//  Created by chaloemphong on 1/6/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol OptionBackViewControllerDelegate {
    func backOptionDiscard()
}

class OptionBackViewController: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var discardBtn: UIButton!
    @IBOutlet weak var stayBtn: UIButton!

    var delegate: OptionBackViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
        
        let background = UIView()
        self.background = background
        self.background.frame = .init(x: 0, y: view.frame.height - 150, width: view.frame.width, height: 150)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.frame.width, height: 150)
        self.background.addSubview(blurView)
        
        let discardBtn = UIButton()
        self.discardBtn = discardBtn
        self.discardBtn.frame = .init(x: 15, y: 15, width: view.frame.width - 30, height: 55)
        self.discardBtn.setTitle("Discard", for: .normal)
        self.discardBtn.backgroundColor = red
        self.discardBtn.setTitleColor(.white, for: .normal)
        self.discardBtn.layer.cornerRadius = 4
        self.discardBtn.addTarget(self, action: #selector(self.discardAction), for: .touchUpInside)
        self.discardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)

        let stayBtn = UIButton()
        self.stayBtn = stayBtn
        self.stayBtn.frame = .init(x: 15, y: 85, width: view.frame.width - 30, height: 55)
        self.stayBtn.setTitle("Stay", for: .normal)
        self.stayBtn.setTitleColor(.white, for: .normal)
        self.stayBtn.addTarget(self, action: #selector(self.stayAction), for: .touchUpInside)
        self.stayBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
        self.background.addSubview(self.stayBtn)
        self.background.addSubview(self.discardBtn)
        self.view.addSubview(self.background)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(stayAction))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func stayAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func discardAction() {
        self.dismiss(animated: false, completion: nil)
        self.delegate?.backOptionDiscard()
    }
}
