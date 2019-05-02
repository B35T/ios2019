//
//  Overframe.swift
//  Overlay2
//
//  Created by chaloemphong on 1/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class Overframe: UIView {
    
    
    
    func add(view: UIView) {
        
        self.frame.size = .init(width:200, height: 200)
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        
        view.addSubview(self)
    }
    
    var show: Bool = true {
        didSet {
            self.layer.borderWidth = self.show ? 1:0
        }
    }
}
