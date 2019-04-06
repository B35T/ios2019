//
//  ColrCROP.swift
//  CropImage2019
//
//  Created by chaloemphong on 29/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public enum setScale: Int {
    case free = 0
    case sq
    case image
    case _32
    case _23
    case _43
    case _34
    case _169
    case _916
    case _219
    case _921
    
    
    var count: Int {
        return 11
    }
    
    func title(i: Int) -> String {
        let t = ["Free", "Sq", "Image", "3:2","2:3", "4:3", "3:4", "16:9", "9:16", "21:9", "9:21"]
        return t[i]
    }
}

open class ColrCROPViewController: UIViewController {
    
    @IBOutlet weak var Grid: grid!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomRight: margin!
    @IBOutlet weak var topLeft: margin!
    var bgview:UIView!
    var topLeft_o: CGRect = .zero
    
    
    
    var scaleRatio: setScale = .image {
        didSet {
            switch self.scaleRatio {
            case .image:
                self.calScale(size: max.size)
                self.Grid.frame = max
            case .free:
                self.ratio = .init(width: 1, height: 1)
            case .sq:
                if max.width >= max.height {
                    self.calScale(size: .init(width: max.height, height: max.height))
                    self.Grid.frame.size.width = self.Grid.frame.height
                } else {
                    self.calScale(size: .init(width: max.width, height: max.width))
                    self.Grid.frame.size.height = self.Grid.frame.width
                }
                self.Grid.center = self.imageView.center
            case ._32:
                self.ratio = .init(width: 1.5, height: 1)
                self.ratioCalculate = self.ratio.width
                self.calculatorGridW()
            case ._23:
                self.ratio = .init(width: 1, height: 1.5)
                self.ratioCalculate = self.ratio.height
                self.calculatorGridH()
            case ._43:
                self.ratio = .init(width: 1.33333, height: 1)
                self.ratioCalculate = self.ratio.width
                self.calculatorGridW()
            case ._34:
                self.ratio = .init(width: 1, height: 1.33333)
                self.ratioCalculate = self.ratio.height
                self.calculatorGridH()
            case ._169:
                self.ratio = .init(width: 1.7777777778, height: 1)
                self.ratioCalculate = self.ratio.width
                self.calculatorGridW()
            case ._916:
                self.ratio = .init(width: 1, height: 1.7777777778)
                self.ratioCalculate = self.ratio.height
                self.calculatorGridH()
            case ._219:
                self.ratio = .init(width: 2.3333333333, height: 1)
                self.ratioCalculate = self.ratio.width
                self.calculatorGridW()
            case ._921:
                self.ratio = .init(width: 1, height: 2.3333333333)
                self.ratioCalculate = self.ratio.height
                self.calculatorGridH()
            }
            
            
            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.createOverlay(alpha: 0.7, rect: self.Grid.frame)
            self.topLeft_o = Grid.frame
        }
    }
    
    var minimumCrop: CGFloat = 1
    var ratioCalculate: CGFloat = 1
    var ratio: CGSize = .init(width: 1, height: 1)
    var max: CGRect = .zero {
        didSet {
            if max.width > max.height {
                self.minimumCrop = max.width / 5
            } else {
                self.minimumCrop = max.height / 5
            }
        }
    }
    public var image: UIImage? {
        didSet {
            if let image = self.image {
                self.imageView.frame = .init(x: 20, y: 20, width: view.frame.width - 40, height: 500)
                self.imageView.image = image
                
                self.imageView.setImageFrame()
                self.max = self.imageView.frame
                self.Grid.rect = self.max
                self.Grid.updateContent()
                self.updateMargin()
                
                
                self.scaleRatio = .image
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        
        let imageView = UIImageView(frame: .init(x: 20, y: 20, width: view.frame.width - 40, height: 500))
        self.imageView = imageView
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = .red
        self.view.addSubview(self.imageView)
        
        let bgview = UIView()
        bgview.frame = view.frame
        bgview.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.bgview = bgview
        self.view.addSubview(self.bgview)
        
        let Grid = grid(frame: .zero)
        Grid.config()
        self.Grid = Grid
        let moveGr = UIPanGestureRecognizer(target: self, action: #selector(moveGrid(_:)))
        self.Grid.addGestureRecognizer(moveGr)
        self.Grid.isUserInteractionEnabled = true
        self.view.addSubview(self.Grid)
        
        let bottomRight = margin(frame: .init(x: 0, y: 0, width: 20, height: 20))
        self.bottomRight = bottomRight
        let moveBr = UIPanGestureRecognizer(target: self, action: #selector(moveBottomRight(_:)))
        self.bottomRight.addGestureRecognizer(moveBr)
        self.bottomRight.isUserInteractionEnabled = true
        self.view.addSubview(self.bottomRight)
        
        let topLeft = margin(frame: .init(x: 0, y: 0, width: 20, height: 20))
        self.topLeft = topLeft
        let moveTopLeft = UIPanGestureRecognizer(target: self, action: #selector(moveTopLeft(_:)))
        self.topLeft.addGestureRecognizer(moveTopLeft)
        self.topLeft.isUserInteractionEnabled = true
        self.view.addSubview(self.topLeft)
        
        self.updateMargin()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func updateMargin() {
        let g = self.Grid.frame
        self.bottomRight.origin = .init(x: g.width + g.origin.x - 10, y: g.height + g.origin.y - 10)
        self.topLeft.center = .init(x: g.origin.x, y: g.origin.y)
    }

    func calScale(size: CGSize) {
        if size.width >= size.height {
            let w = size.width / size.height
            self.ratio = .init(width: w, height: 1)
            self.ratioCalculate = w
        }  else {
            let h = size.height / size.width
            self.ratio = .init(width: 1, height: h)
            self.ratioCalculate = h
        }
    }
    
    
    func calculatorGridW() {
        
        var w = max.width
        var h = max.width / ratioCalculate
        
        if h > max.height {
            h = max.height
            w = h * ratioCalculate
        }

        self.Grid.frame.size = .init(width: w, height: h)
        
        self.Grid.center = self.imageView.center
    }
    
    func calculatorGridH() {
        var h = max.height
        var w = max.height / ratioCalculate
        
        if w > max.width {
            w = max.width
            h = w * ratioCalculate
        }
        
        self.Grid.frame.size = .init(width: w, height: h)
        
        self.Grid.center = self.imageView.center
    }
}

extension ColrCROPViewController {
    @objc internal func moveGrid(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            if view.frame != self.max {
                view.center = .init(x: view.center.x + t.x, y: view.center.y + t.y)
            }
            
            if view.frame.origin.x <= max.origin.x {
                view.frame.origin.x = max.origin.x
            }
            
            if view.frame.origin.y <= max.origin.y {
                view.frame.origin.y = max.origin.y
            }
            
            let max_x = ((self.imageView.frame.width - max.width) / 2) + (max.width - view.frame.width) + self.imageView.frame.origin.x
            if view.frame.origin.x >= max_x {
                view.frame.origin.x = max_x
            }
            
            let max_y = ((self.imageView.frame.height - max.height) / 2) + (max.height - view.frame.height) + self.imageView.frame.origin.y
            if view.frame.origin.y >= max_y {
                view.frame.origin.y = max_y
            }
            
            self.updateMargin()
        }
        
        
        self.bgview.createOverlay(alpha: 0.7, rect: self.Grid.frame)
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveTopLeft(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            let x = (view.center.x + t.x)
            let y = (view.center.y + t.y)

            
            switch sender.state {
            case .began: self.topLeft_o = self.Grid.frame
            case .ended: self.topLeft_o = self.Grid.frame; print(self.Grid.frame)
            case .changed:
                let cal_w = -(topLeft_o.origin.x - x) - topLeft_o.width
                let cal_h = -(topLeft_o.origin.y - y) - topLeft_o.height
                
                
                switch self.scaleRatio {
                case .free:
                    
                    
                    if -cal_w >= minimumCrop && -cal_w <= self.max.width && x >= self.max.origin.x {
                        view.center.x = x
                        Grid.frame.origin.x = x
                        Grid.frame.size.width = -cal_w
                    }
                    
                    if -cal_h >= minimumCrop && -cal_h <= self.max.height && y >= self.max.origin.y {
                        view.center.y = y
                        Grid.frame.origin.y = y
                        Grid.frame.size.height = -cal_h
                    }
                    
                default:
                    if ratio.width > ratio.height {
                        view.center.x = x
                        Grid.frame.origin.x = x
                        Grid.frame.size.width = -cal_w
                    } else {
                        view.center.y = y
                        Grid.frame.origin.y = y
                        Grid.frame.size.height = -cal_h
                    }
                }
            default: break
            }
            
            

            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.createOverlay(alpha: 0.7, rect: self.Grid.frame)
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveBottomRight(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            let x = view.center.x + t.x
            let y = view.center.y + t.y
            
            let w = x - self.Grid.frame.origin.x
            let h = y - self.Grid.frame.origin.y
            
            topLeft_o = Grid.frame
            switch self.scaleRatio {
            case .free:
                
                if x <= self.max.maxX && w >= self.minimumCrop {
                    view.center.x = x
                    self.Grid.frame.size.width = w
                }
                
                if y <= self.max.maxY && h >= self.minimumCrop {
                    view.center.y = y
                    self.Grid.frame.size.height = h
                }

            default:
                let multi_h = w * ratioCalculate

                if ratio.height >= ratio.width {
                    let max_y =  multi + Grid.frame.origin.y
                    if max_y <= max.maxY && x <= max.maxX && multi >= minimumCrop {
                        view.center.x = x
                        self.Grid.frame.size.width = w
                        self.Grid.frame.size.height = multi_h
                    }
                } else {
                    let multi = w / ratioCalculate
                    let max_y =  multi + Grid.frame.origin.y
                    if max_y <= max.maxY && x <= max.maxX && multi_h >= minimumCrop {
                        view.center.x = x
                        self.Grid.frame.size.width = w
                        self.Grid.frame.size.height = multi
                    }
                    
                }
                
            }
                
            

            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.createOverlay(alpha: 0.7, rect: self.Grid.frame)
            
        }
        
        sender.setTranslation(.zero, in: self.view)
    }

    
}

extension UIImageView {
    func setImageFrame() {
        var r:CGRect = .zero
        if let s = image?.size {
            
            let c = s.width / s.height
            let h = self.frame.width / c
            let y = (self.frame.height / 2) - (h / 2) + self.frame.origin.y
            
            if h > self.frame.height {
                let c = s.height / s.width
                let w = self.frame.height / c
                let x = (self.frame.width / 2) - (w / 2) + self.frame.origin.x
                r = .init(x: x, y: self.frame.origin.y, width: w, height: self.frame.height)
            } else {
                r = .init(x: self.frame.origin.x, y: y, width: self.frame.width, height: h)
            }
        }
        self.frame = r
    }
}

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

