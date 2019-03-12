//
//  CropGridView.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class GridLayer: UIView {

    open override var frame: CGRect {
        didSet {
        }
    }
    
 
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }

 
}
