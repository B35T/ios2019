//
//  OverayView.swift
//  Colr
//
//  Created by chaloemphong on 19/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class OverlayImage: UIView {
    var imageview: UIImageView = UIImageView()
    var alphaImage:CGFloat = 1.0 {
        didSet {
            self.imageview.alpha = self.alphaImage
        }
    }
    
    func overlay(view: UIView, image:UIImage?) {
        guard let image = image else {return}
        let w = view.frame.width / 2
        self.frame.size = .init(width: w, height: w)
        self.imageview.frame.size = .init(width: w, height: w)
        self.imageview.image = image

        self.layer.compositingFilter = "screenBlendMode"
//        self.imageview.layer.compositingFilter = "screenBlendMode"
        self.center = view.center
        self.addSubview(self.imageview)
        view.addSubview(self)
        
    }
}
