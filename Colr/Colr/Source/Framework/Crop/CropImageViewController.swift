//
//  CropImageViewController.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class CropImageViewController: UIViewController {

    @IBOutlet open weak var imageView: UIImageView!
    
    enum condition {
        case มากกว่าหรือเท่ากับ
        case น้อยกว่าหรือเท่ากับ
        case น้อยกว่า
        case มากกว่า
        case เท่ากับ
    }
    
    var grid: GridLayer!

    var bgview: UIView!
    var bottom_right: UIView!
    var top_left: UIView!
    var top_right: UIView!
    var bottom_left: UIView!
    
    var o:CGRect = .zero
    
    var image:UIImage? {
        didSet {
            if let img = image {
                self.imageView.image = img
                self.grid.frame = self.calculator
                self.update()
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        self.view.isUserInteractionEnabled = true
        
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        self.imageView.frame = .init(x: 20, y: 40, width: view.w - 40, height: view.h.persen(p: 70))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.layer.cornerRadius = 4
        self.view.addSubview(self.imageView)
        
        
        self.bgview = UIView()
        self.bgview.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(bgview)
        
        self.bgview = UIView()
        self.bgview.frame = .init(x: 0, y: 0, width: view.w, height: view.h)
        self.bgview.backgroundColor = UIColor.black
        self.view.addSubview(bgview)
        
        let grid = GridLayer()
        self.grid = grid
        self.grid.addLine = true
        self.grid.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapResetAction(_:)))
        let moveGrid = UIPanGestureRecognizer(target: self, action: #selector(moveGrid(_:)))
        self.grid.addGestureRecognizer(moveGrid)
        self.grid.addGestureRecognizer(tap)
        self.view.addSubview(self.grid)
        
        
        
        self.bottom_right = UIView()
        self.bottom_right.frame.size = .init(width: 20, height: 20)
        let moveRight = UIPanGestureRecognizer(target: self, action: #selector(moveBottomRight(_:)))
        self.bottom_right.addGestureRecognizer(moveRight)
        self.bottom_right.isUserInteractionEnabled = true
        self.bottom_right.backgroundColor = .white
        self.bottom_right.layer.cornerRadius = 10
        self.bottom_right.layer.shadowColor = UIColor.gray.cgColor
        self.bottom_right.layer.shadowOpacity = 0.3
        self.bottom_right.layer.shadowRadius = 3
        self.view.addSubview(self.bottom_right)
        
        self.top_left = UIView()
        self.top_left.frame.size = .init(width: 20, height: 20)
        let moveTopL = UIPanGestureRecognizer(target: self, action: #selector(moveTopLeft(_:)))
        self.top_left.addGestureRecognizer(moveTopL)
        self.top_left.isUserInteractionEnabled = true
        self.top_left.backgroundColor = .white
        self.top_left.layer.cornerRadius = 10
        self.top_left.layer.shadowColor = UIColor.gray.cgColor
        self.top_left.layer.shadowOpacity = 0.3
        self.top_left.layer.shadowRadius = 3
        self.view.addSubview(self.top_left)
        
        self.top_right = UIView()
        self.top_right.frame.size = .init(width: 20, height: 20)
        self.top_right.isUserInteractionEnabled = true
        self.top_right.backgroundColor = .white
        self.top_right.layer.cornerRadius = 10
        self.top_right.layer.shadowColor = UIColor.gray.cgColor
        self.top_right.layer.shadowOpacity = 0.3
        self.top_right.layer.shadowRadius = 3
        self.view.addSubview(self.top_right)
        
        self.bottom_left = UIView()
        self.bottom_left.frame.size = .init(width: 20, height: 20)
        self.bottom_left.isUserInteractionEnabled = true
        self.bottom_left.backgroundColor = .white
        self.bottom_left.layer.cornerRadius = 10
        self.bottom_left.layer.shadowColor = UIColor.gray.cgColor
        self.bottom_left.layer.shadowOpacity = 0.3
        self.bottom_left.layer.shadowRadius = 3
        self.view.addSubview(self.bottom_left)
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func hide(t_l:CGFloat = 1, t_r:CGFloat = 1, b_l: CGFloat = 1, b_r: CGFloat = 1) {
        self.top_left.alpha = t_l
        self.top_right.alpha = t_r
        self.bottom_left.alpha = b_l
        self.bottom_right.alpha = b_r
    }

    var calculator: CGRect {
        var r:CGRect = .zero
        if let s = image?.size {
            
            let c = s.width / s.height
            let h = self.imageView.w / c
            let y = (imageView.h / 2) - (h / 2) + imageView.y
            
            if h > imageView.h {
                let c = s.height / s.width
                let w = imageView.h / c
                let x = (imageView.w / 2) - (w / 2) + imageView.x
                r = .init(x: x, y: imageView.y, width: w, height: imageView.h)
            } else {
                r = .init(x: imageView.x, y: y, width: imageView.w, height: h)
            }
        }
        return r
    }
 
    func update() {
        self.top_left.center = .init(x: self.grid.x, y: self.grid.y)
        self.top_right.center = .init(x: self.grid.w + grid.x, y: self.grid.y)
        self.bottom_left.center = .init(x: self.grid.x, y: self.grid.h + self.grid.y)
        self.bottom_right.center = .init(x: self.grid.w + self.grid.x, y:  self.grid.h + self.grid.y)
        
        self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
        self.grid.update()
    }
}

extension CropImageViewController {
    @objc internal func tapResetAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.grid.frame = self.calculator
            self.update()
        }
    }
    
    @objc internal func moveGrid(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            switch sender.state {
            case .changed:
                self.hide(t_l: 0, t_r: 0, b_l: 0, b_r: 0)
                
                if view.frame != self.calculator {
                    view.center = .init(x: view.center.x + translation.x, y: view.center.y + translation.y)
                }
                
                if view.x <= calculator.origin.x {
                    view.frame.origin.x = calculator.origin.x
                }
                
                if view.y <= calculator.origin.y {
                    view.frame.origin.y = calculator.origin.y
                }
                
                let max_x = ((self.imageView.w - calculator.width) / 2) + (calculator.width - view.w) + imageView.x
                if view.x >= max_x {
                    view.frame.origin.x = max_x
                }
                
                let max_y = ((self.imageView.h - calculator.height) / 2) + (calculator.height - view.h) + imageView.y
                if view.y >= max_y {
                    view.frame.origin.y = max_y
                }
                
                self.grid.update()
                self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
            case .ended:
                self.update()
                UIView.animate(withDuration: 0.2) {
                    self.hide()
                }
            default:
                break
            }
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveBottomRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            let x = view.center.x + translation.x
            let y = view.center.y + translation.y
            
            let w = x - self.grid.x
            let h = y - self.grid.y
            
            switch sender.state {
            case .changed:
                if x <=  self.calculator.width + self.calculator.origin.x && w >= 100 {
                    view.center.x = view.center.x + translation.x
                    
                    let w = view.x - grid.x
                    self.grid.frame.size.width = w + 10
                }
                
                if y <= self.calculator.height + self.calculator.origin.y && h >= 100 {
                    view.center.y = view.center.y + translation.y
                    
                    let h = view.y - grid.y
                    self.grid.frame.size.height = h + 10
                }
                
                
                self.hide(t_l: 0, t_r: 0, b_l: 0)
                self.grid.update()
                self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
            case .ended:
                self.hide()
                self.update()
                self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
            default: break
            }
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    func stop(condition: condition, point:CGFloat , input: CGFloat, completion: @escaping ((_ output: CGFloat) -> ())) {
        switch condition {
        case .เท่ากับ:
            if point == input {completion(input) }
        case .น้อยกว่าหรือเท่ากับ:
            if point <= input {} else {completion(input)}
        case .มากกว่าหรือเท่ากับ:
            if point >= input {} else {completion(input)}
        case .น้อยกว่า:
            if point < input {completion(input)}
        case .มากกว่า:
            if point > input {completion(input)}
        }
    }
    
    @objc internal func moveTopLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if let view = sender.view {
            let x = view.center.x + translation.x
            let y = view.center.y + translation.y

            let cal_x = (self.calculator.width + self.calculator.origin.x) - x
            let cal_y = (self.calculator.height + self.calculator.origin.y) - y
            
            switch sender.state {
            case .began: self.o = self.grid.frame
            case .changed:
            
                if cal_x >= 100 && x >= self.calculator.origin.x {
                    view.center.x = x
                    self.grid.frame.origin.x = x
                    
                    let cal_w = -(o.origin.x - grid.x) - o.width
                    
                    
                    if cal_w <= -100 {
                        self.grid.frame.size.width = -cal_w
                    }
                    
                }
                
                if cal_y >= 100 && y >= self.calculator.origin.y {
                    view.center.y = y
                    self.grid.frame.origin.y = y
                    
                    let cal_h = -(o.origin.y - grid.y) - o.height
                    
                    if cal_h <= -100  {
                        self.grid.frame.size.height = -cal_h
                    }
                }
                
                
                self.grid.update()
                self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
                self.hide(t_r: 0, b_l: 0, b_r: 0)
                
            case .ended:
                self.o = self.grid.frame

                let w = grid.w + grid.x > calculator.width
                let h = grid.h + grid.y > calculator.height
                if w {
                    self.grid.frame.origin.x = (calculator.width - grid.w) + calculator.origin.x
                }
                
                if h {
                    self.grid.frame.origin.y = (calculator.height - grid.h) + calculator.origin.y
                }
                
                if self.grid.x < self.calculator.origin.x {
                    self.grid.frame.origin.x = self.calculator.origin.x
                }

                if self.grid.y < self.calculator.origin.y {
                    self.grid.frame.origin.y = self.calculator.origin.y
                }
                self.update()
                self.hide()
                self.bgview.createOverlay(alpha: 0.5, rect: grid.frame)
            default: break
            }
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
}
