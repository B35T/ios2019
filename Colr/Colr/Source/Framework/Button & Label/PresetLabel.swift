//
//  PresetLabel.swift
//  Colr
//
//  Created by chaloemphong on 28/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class PresetLabel: CustomLabel {
    
    open override func x(view: UIView) {
        self.center.x = view.center.x
    }
    
    open override func setup(font:UIFont = UIFont.boldSystemFont(ofSize: 14)) {
        super.setup(font: font)
        
        self.textColor = .white
        self.backgroundColor = .clear
        self.font = font
    }
    
    open override func add(view:UIView,_ p: CGPoint = .zero, _ s: CGSize = CGSize(width: 110, height: 40)) {
        super.add(view: view, p, s)
        self.frame = .init(origin: p, size: s)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 13)
        self.textColor = .darkGray
        view.addSubview(self)
    }
    
    
    
}
