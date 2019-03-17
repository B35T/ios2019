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
            self.update()
        }
    }
    
    var tx: UIView!
    var moving: UIView!

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

        let tx = UIView()
        self.tx = tx
        self.tx.frame.size = .init(width: 20, height: 20)
        self.tx.backgroundColor = .white
        self.tx.layer.cornerRadius = 10
        self.addSubview(self.tx)
        
        let panmove = UIPanGestureRecognizer(target: self, action: #selector(panmoveaction))
        self.tx.addGestureRecognizer(panmove)
        self.tx.isUserInteractionEnabled = true
        
        let moving = UIView()
        self.moving = moving
        self.moving.frame.size = .init(width: 20, height: 20)
        self.moving.backgroundColor = .white
        self.moving.layer.cornerRadius = 10
        self.addSubview(self.moving)
        
        let panMoving = UIPanGestureRecognizer(target: self, action: #selector(movingAction(_:)))
        
        self.moving.addGestureRecognizer(panMoving)
        self.moving.isUserInteractionEnabled = true
    }
    
    var o:CGRect = .zero
    @objc internal func movingAction(_ gesture:UIPanGestureRecognizer) {
        let t = gesture.translation(in: self)
        if let view = gesture.view {
            switch gesture.state {
            case .began:
                o = grid.frame
                print("begin \(o)")
            case .changed:
                self.tx.alpha = 0
//                view.center = .init(x: view.center.x + t.x, y: view.center.y + t.y)
                
                let x = view.center.x - 2
                let y = view.center.y - 2
                self.grid.frame.origin = .init(x: x, y: y)
                
                let c = (o.origin.x - grid.x)
                let w = -c - o.width
                
                let c2 = (o.origin.y - grid.y)
                let h = -c2 - o.height
                
                if grid.w >= 100 {
                    view.center.x = view.center.x + t.x
                    self.grid.frame.size.width = -w
                }
                
                if grid.h >= 100 {
                    view.center.y = view.center.y + t.y
                    self.grid.frame.size.height = -h
                }
                print(x, y)
               
            case .ended:
                o = grid.frame
                print("end \(o)")
                UIView.animate(withDuration: 0.3) {
                    self.tx.alpha = 1
                    if self.grid.w <= 100 {
                        self.grid.frame.size.width = 100
                    }
                    
                    if self.grid.h <= 100 {
                        self.grid.frame.size.height = 100
                    }
                    
                    
                    if self.grid.h > self.calculator.height {
                        self.grid.frame.size.height = self.calculator.height
                    }
                    
                    if self.grid.w > self.calculator.width {
                        self.grid.frame.size.width = self.calculator.width
                    }
                    self.update()
                }
                
                break
            default:
                break
            }
        }
        
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc internal func panmoveaction(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self)
        if let view = sender.view {
            
            switch sender.state {
            case .changed:
                
                let x = view.center.x + t.x
                let y = view.center.y + t.y

                if y - calculator.origin.y >= 100 && y - calculator.origin.y <= self.calculator.height {
                    view.center.y = y
                    self.grid.frame.size.height = (view.frame.origin.y - grid.frame.origin.y) + 12
                }
                
                if x >= 100 && x <= self.calculator.width {
                    view.center.x = x
                    self.grid.frame.size.width = (view.frame.origin.x - grid.frame.origin.x) + 12
                }
                
                

            case .ended:
                UIView.animate(withDuration: 0.3) {
                    if self.grid.w <= 100 {
                        self.grid.frame.size.width = 100
                    }
                    
                    if self.grid.h <= 100 {
                        self.grid.frame.size.height = 100
                    }

                    
                    if self.grid.h > self.calculator.height {
                        self.grid.frame.size.height = self.calculator.height
                    }
                    
                    if self.grid.w > self.calculator.width {
                        self.grid.frame.size.width = self.calculator.width
                    }
                    self.update()
                }
                
                
            default:
                break
            }
            
        }
        
        sender.setTranslation(.zero, in: self)
    }
    
    
    @objc internal func Move(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        guard let view = gesture.view else {return}
        switch gesture.state {
        case .changed:
            self.tx.alpha = 0
            self.moving.alpha = 0
            
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
            
        case .ended:
            self.update()
            UIView.animate(withDuration: 0.2) {
                self.tx.alpha = 1
                self.moving.alpha = 1
            }
        default:
            break
        }
        
        gesture.setTranslation(.zero, in: self)
    }
    
    @objc internal func tapAction(_ gesture: UITapGestureRecognizer) {
        self.grid.frame = calculator
        self.update()
    }
    
    func update() {
        let x = (grid.w - 12) + grid.frame.origin.x
        let y = (grid.h - 12) + grid.frame.origin.y
        self.tx.frame.origin = .init(x: x, y: y)
        
        let mx = grid.frame.origin.x - 8
        let my = grid.frame.origin.y - 8
        self.moving.frame.origin = .init(x: mx, y: my)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}
