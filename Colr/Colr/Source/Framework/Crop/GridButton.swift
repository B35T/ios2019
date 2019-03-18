//
//  GridButton.swift
//  Colr
//
//  Created by chaloemphong on 18/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class GridButton: UIButton {
    
    override func layoutSublayers(of layer: CALayer) {
        self.frame.size = .init(width: 20, height: 20)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
    }
}
