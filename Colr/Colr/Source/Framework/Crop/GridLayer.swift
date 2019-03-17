//
//  CropGridView.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class GridLayer: UIView {
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }

 
}
