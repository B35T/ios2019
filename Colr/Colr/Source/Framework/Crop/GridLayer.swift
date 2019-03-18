//
//  CropGridView.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class GridLayer: UIView {
    var hor_t = UIView()
    var hor_b = UIView()
    var ver_l = UIView()
    var ver_r = UIView()
    
    var addLine:Bool = false {
        didSet {
            if self.addLine {
                
                let color = UIColor.white.withAlphaComponent(0.7)
                
                self.hor_t.backgroundColor = color
                self.hor_b.backgroundColor = color
                self.ver_l.backgroundColor = color
                self.ver_r.backgroundColor = color
                
                self.addSubview(self.hor_t)
                self.addSubview(self.hor_b)
                self.addSubview(self.ver_l)
                self.addSubview(self.ver_r)
            }
        }
    }
    
    func update() {
        let y = self.h / 3
        let x = self.w / 3
        
        self.hor_t.frame = .init(x: 0, y: y, width: self.w, height: 0.5)
        self.hor_b.frame = .init(x: 0, y: y * 2, width: self.w, height: 0.5)
        self.ver_l.frame = .init(x: x, y: 0, width: 0.5, height: self.h)
        self.ver_r.frame = .init(x: x * 2, y: 0, width: 0.5, height: self.h)
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }

 
}
