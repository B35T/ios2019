//
//  OverlayValue.swift
//  Colr
//
//  Created by chaloemphong on 2/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class OverlayValue {
    
    var label = UILabel()
    
    class var shared: OverlayValue {
        struct Static {
            static let instance: OverlayValue = OverlayValue()
        }
        return Static.instance
    }
    
    func showOverlay(view: UIView, value:CGFloat, center: CGPoint) {
        self.label.frame.size = .init(width: 200, height: 100)
        self.label.center = center
        self.label.textColor = .white
        self.label.font = UIFont.boldSystemFont(ofSize: 56)
        self.label.text = "𝜶 \(String(format: "%0.0f", value * 100))%"
        self.label.alpha = 1
        self.label.textAlignment = .center
        
        view.addSubview(self.label)
    }
    
    func hidden() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.label.alpha = 0
        }, completion: nil)
    }
}
