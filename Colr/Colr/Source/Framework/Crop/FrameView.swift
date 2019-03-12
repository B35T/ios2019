//
//  GridView.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class FrameView:UIView {
    
    var grid: GridLayer!
    var calculator: CGRect = .zero {
        didSet {
            self.grid.frame = calculator
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        
        let grid = GridLayer()
        self.grid = grid
        
        self.addSubview(self.grid)
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(Move(_:)))
        self.grid.isUserInteractionEnabled = true
        self.grid.addGestureRecognizer(move)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 2
        self.grid.addGestureRecognizer(tap)

    }
    
    
    @objc internal func Move(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        guard let view = gesture.view else {return}
        switch gesture.state {
        case .changed:
            
            if view.frame != calculator {
                view.center = .init(x: view.center.x + translation.x, y: view.center.y + translation.y)
            }
            
            if view.x <= calculator.origin.x {
                view.frame.origin.x = calculator.origin.x
            }
            
            if view.y <= calculator.origin.y {
                view.frame.origin.y = calculator.origin.y
            }
            
            if view.x >= ((self.w - calculator.width) / 2) + (calculator.width - view.w) {
                view.frame.origin.x = ((self.w - calculator.width) / 2) + (calculator.width - view.w)
            }

            if view.y >= ((self.h - calculator.height) / 2) + (calculator.height - view.h) {
                view.frame.origin.y = ((self.h - calculator.height) / 2) + (calculator.height - view.h)
            }
        default:
            break
        }
        
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc internal func tapAction(_ gesture: UITapGestureRecognizer) {
        self.grid.frame.size = .init(width: 200, height: 200)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}
