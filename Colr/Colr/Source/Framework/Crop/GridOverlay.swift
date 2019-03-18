//
//  GridOverlay.swift
//  Colr
//
//  Created by chaloemphong on 18/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension UIView {
    func createOverlay(alpha:CGFloat, rect:CGRect) {
        self.alpha = alpha
        let path = UIBezierPath(roundedRect: self.frame,cornerRadius: 0)
        
        let circle = UIBezierPath(roundedRect: CGRect (origin: CGPoint(x:rect.origin.x, y: rect.origin.y),
                                                       size: CGSize(width: rect.width, height: rect.height)), cornerRadius: 0)
        
        path.append(circle)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.duration = 2
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = maskLayer
    }
}
