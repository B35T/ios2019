//
//  NextBar.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class NextBar: UIView {
    
    @IBOutlet open weak var close: UIButton!

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initailize()
        
    }
    
    open func animation(point: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.frame.origin = point
        }
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initailize() {
        let close = UIButton()
        self.close = close
        self.close.frame = .init(x: 10, y: 5, width: 80, height: 40)
        self.close.layer.compositingFilter = "screenBlendMode"
        
        self.addSubview(self.close)
        self.close.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}
