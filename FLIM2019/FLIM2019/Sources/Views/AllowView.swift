//
//  AllowView.swift
//  FLIM2019
//
//  Created by chaloemphong on 16/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class AllowView: UIView {
    
    @IBOutlet weak var btn: UIButton!
    
    open func initialize(view: UIView, title:String = "Allow Access To Photos And Camera") {

        self.frame = view.frame
        self.backgroundColor = .white
        
        let btn = UIButton()
        self.btn = btn
        self.btn.frame.size = .init(width: view.frame.width - 20, height: 55)
        self.btn.center = self.center
        self.btn.backgroundColor = blue
        self.btn.setTitle(title, for: .normal)
        self.btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        self.btn.setTitleColor(.white, for: .normal)
        self.btn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        self.btn.layer.cornerRadius = 4
        self.btn.clipsToBounds = true
        self.addSubview(self.btn)
        
//        self.bringSubviewToFront(self)
        view.addSubview(self)
    }
    
    @objc internal func btnAction() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
