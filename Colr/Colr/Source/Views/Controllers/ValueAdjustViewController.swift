//
//  ValueAdjustViewController.swift
//  Colr
//
//  Created by chaloemphong on 15/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol ValueAdjustViewControllerDelegate {
    func ValueAdjust(value:Float, title:String)
}

class ValueAdjustViewController: UIViewController {

    @IBOutlet weak var backgoundview: UIView!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    
    let labelTitle = PresetLabel()
    var delegate: ValueAdjustViewControllerDelegate?
    var ProcessEngineProfile:ProcessEngineProfileModel?
    var ovalue:Float = 0.5
    var value:Float = 0.5 {
        didSet {
            let str = String(format: "%0.2f", self.value)
            self.sliderValue.value = self.value
            self.labelValue.text = str
        }
    }
    
    var titles:String = "" {
        didSet {
            self.labelTitle.text = self.titles
        }
    }
    
    override func loadView() {
        super.loadView()
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.w, height: 200)
        self.backgoundview.addSubview(blurView)
        
        self.backgoundview.frame = .init(x: 0, y: view.h.minus(n: 175), width: view.w, height: 175)
        self.backgoundview.backgroundColor = .clear
        
        self.labelValue.frame = .init(x: view.w / 2 - 35, y: 10, width: 70, height: 30)
        self.labelValue.backgroundColor = UIColor(red: 255/255, green: 212/255, blue: 31/255, alpha: 1)
        self.labelValue.layer.cornerRadius = 4
        self.labelValue.clipsToBounds = true
        self.labelValue.text = "0.5"
        
        self.sliderValue.frame = .init(x: 10, y: 50, width: view.w - 20, height: 30)
        
        self.backgoundview.addSubview(self.labelValue)
        self.backgoundview.addSubview(self.sliderValue)
        self.view.addSubview(self.backgoundview)
        
        let closeBtn = CloseButtonIcon()
        closeBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: view.h - 60))
        
        let chooseBtn = ChooseButtonIcon()
        chooseBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        chooseBtn.add(view: view, .init(x: view.w - 60, y: view.h - 60))
        
        
        labelTitle.add(view: view)
        labelTitle.setup()
        labelTitle.frame.origin.y = view.h - 55
        labelTitle.center.x = view.center.x
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let v = self.ProcessEngineProfile?.get(name: self.titles) {
            self.value = v.toFloat
            self.ovalue = v.toFloat
        }
    }
    
    @objc internal func ResetToCenter() {
        self.sliderValue.value = 0.5
        self.value = 0.5
    }
    
    @objc internal func doneAction() {
        self.delegate?.ValueAdjust(value: self.sliderValue.value, title: self.titles)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func dismissAction() {
        self.sliderValue.value = self.ovalue
        self.value = self.ovalue
        self.delegate?.ValueAdjust(value: self.ovalue, title: self.titles)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        self.value = sender.value
        self.delegate?.ValueAdjust(value: sender.value, title: self.titles)
    }
}
