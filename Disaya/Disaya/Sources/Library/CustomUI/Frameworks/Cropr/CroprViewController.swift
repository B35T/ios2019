//
//  ColrCROP.swift
//  CropImage2019
//
//  Created by chaloemphong on 29/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public enum setScale: Int {
    case image = 0
    case free
    case sq
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

open class CroprViewController: UIViewController {
    
    @IBOutlet weak var Grid: GridOverlay!
    @IBOutlet weak var imageView: imageScrollView!
    @IBOutlet weak var bottomRight: margin!
    @IBOutlet weak var topLeft: margin!
    @IBOutlet weak var topRight: margin!
    @IBOutlet weak var bottomLeft: margin!
    var bgview:UIView!
    var topLeft_o: CGRect = .zero
    var cropZone: CGRect = .zero
    
    
    var scaleRatio: setScale = .image {
        didSet {
            switch self.scaleRatio {
            case .image:
                self.calScale(size: maxScope.size)
                self.Grid.frame = maxScope
            case .free:
                self.ratio = .init(width: 1, height: 1)
            case .sq:
                if maxScope.width >= maxScope.height {
                    self.calScale(size: .init(width: maxScope.height, height: maxScope.height))
                    self.Grid.frame.size.width = self.Grid.frame.height
                } else {
                    self.calScale(size: .init(width: maxScope.width, height: maxScope.width))
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
            self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
            self.topLeft_o = Grid.frame
        }
    }
    
    var minimumCrop: CGFloat = 1
    var ratioCalculate: CGFloat = 1
    var ratio: CGSize = .init(width: 1, height: 1)
    var maxScope: CGRect = .zero {
        didSet {
            if maxScope.width > maxScope.height {
                self.minimumCrop = maxScope.height / 5
            } else {
                self.minimumCrop = maxScope.width / 5
            }
        }
    }
    public var image: UIImage? {
        didSet {
            if let image = self.image {
                
                self.imageView.image = image
                self.imageView.rect = .init(x: 20, y: 30, width: view.frame.width - 40, height: view.frame.height - 220)
                self.maxScope = self.imageView.frame
                self.Grid.rect = self.maxScope
                self.Grid.updateContent()
                self.updateMargin()
                
                self.scaleRatio = .image
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        
        let imageView = imageScrollView(frame: .init(x: 20, y: 20, width: view.frame.width - 40, height: view.frame.height / 100 * 75))
        self.imageView = imageView
        self.imageView.config()
        self.view.addSubview(self.imageView)
        
        let bgview = UIView()
        bgview.frame = view.frame
        bgview.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.bgview = bgview
        self.view.addSubview(self.bgview)
        
        let Grid = GridOverlay(frame: .zero)
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
        
        let topRight = margin(frame: .init(x: 0, y: 0, width: 20, height: 20))
        self.topRight = topRight
        let moveTopRight = UIPanGestureRecognizer(target: self, action: #selector(moveTopRight(_:)))
        self.topRight.addGestureRecognizer(moveTopRight)
        self.topRight.isUserInteractionEnabled = true
        self.view.addSubview(self.topRight)
        
        let bottomLeft = margin(frame: .init(x: 0, y: 0, width: 20, height: 20))
        self.bottomLeft = bottomLeft
        let moveBottomLeft = UIPanGestureRecognizer(target: self, action: #selector(moveBottomLeft(_:)))
        self.bottomLeft.addGestureRecognizer(moveBottomLeft)
        self.bottomLeft.isUserInteractionEnabled = true
        self.view.addSubview(self.bottomLeft)
        
        self.updateMargin()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
    }
    
    
    
    func updateMargin() {
        let g = self.Grid.frame
        self.bottomRight.origin = .init(x: g.maxX - 10, y: g.maxY - 10)
        self.topLeft.center = .init(x: g.origin.x, y: g.origin.y)
        self.topRight.center = .init(x: g.maxX, y: g.origin.y)
        self.bottomLeft.origin = .init(x: g.origin.x - 10, y: g.maxY - 10)
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
        
        var w = maxScope.width
        var h = maxScope.width / ratioCalculate
        
        if h > maxScope.height {
            h = maxScope.height
            w = h * ratioCalculate
        }
        
        self.Grid.frame.size = .init(width: w, height: h)
        
        self.Grid.center = self.imageView.center
    }
    
    func calculatorGridH() {
        var h = maxScope.height
        var w = maxScope.height / ratioCalculate
        
        if w > maxScope.width {
            w = maxScope.width
            h = w * ratioCalculate
        }
        
        self.Grid.frame.size = .init(width: w, height: h)
        
        self.Grid.center = self.imageView.center
    }
    
    func cropping() -> (CGSize?,CGRect?) {
        guard let image = image else {return (.zero,.zero)}
        let rect = Grid.frame
        let imageScale:CGFloat = Swift.max(image.size.width / self.maxScope.width , image.size.height / self.maxScope.height)
        
        let cropZone = CGRect(x: (rect.origin.x - self.maxScope.origin.x) * imageScale, y: (rect.origin.y - self.maxScope.origin.y) * imageScale, width: rect.width * imageScale, height: rect.height * imageScale)
        
        self.cropZone = cropZone
        return (image.size, cropZone)
    }
}

extension CroprViewController {
    @objc internal func moveGrid(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            if view.frame != self.maxScope {
                view.center = .init(x: view.center.x + t.x, y: view.center.y + t.y)
            }
            
            if view.frame.origin.x <= maxScope.origin.x {
                view.frame.origin.x = maxScope.origin.x
            }
            
            if view.frame.origin.y <= maxScope.origin.y {
                view.frame.origin.y = maxScope.origin.y
            }
            
            let max_x = ((self.imageView.frame.width - maxScope.width) / 2) + (maxScope.width - view.frame.width) + self.imageView.frame.origin.x
            if view.frame.origin.x >= max_x {
                view.frame.origin.x = max_x
            }
            
            let max_y = ((self.imageView.frame.height - maxScope.height) / 2) + (maxScope.height - view.frame.height) + self.imageView.frame.origin.y
            if view.frame.origin.y >= max_y {
                view.frame.origin.y = max_y
            }
            
            self.updateMargin()
        }
        
        
        self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveTopLeft(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            let x = (view.center.x + t.x)
            let y = (view.center.y + t.y)
            
            
            switch sender.state {
            case .began: self.topLeft_o = self.Grid.frame
            case .ended: self.topLeft_o = self.Grid.frame
            case .changed:
                let width = topLeft_o.maxX - x
                let height = topLeft_o.maxY - y
                
                switch self.scaleRatio {
                case .free:
                    if width >= minimumCrop && width <= self.maxScope.width && x >= self.maxScope.origin.x {
                        view.center.x = x
                        Grid.frame.origin.x = x
                        Grid.frame.size.width = width
                    }
                    
                    if height >= minimumCrop && height <= self.maxScope.height && y >= self.maxScope.origin.y {
                        view.center.y = y
                        Grid.frame.origin.y = y
                        Grid.frame.size.height = height
                    }
                    
                default:
                    if ratio.height > ratio.width {
                        let h = width * ratioCalculate
                        let y = topLeft_o.maxY - h
                        
                        if y >= self.maxScope.origin.y && x >= self.maxScope.origin.x && width >= minimumCrop && height >= minimumCrop {
                            view.center.x = x
                            Grid.frame.origin.x = x
                            Grid.frame.size.width = width
                            Grid.frame.origin.y = y
                            Grid.frame.size.height = h
                        }
                        
                    } else {
                        let h = width / ratioCalculate
                        let y = topLeft_o.maxY - h
                        
                        if y >= self.maxScope.origin.y && x >= self.maxScope.origin.x && width >= minimumCrop && height >= minimumCrop {
                            view.center.x = x
                            Grid.frame.origin.x = x
                            Grid.frame.size.width = width
                            Grid.frame.origin.y = y
                            Grid.frame.size.height = h
                        }
                    }
                    
                }
            default: break
            }
            
            
            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveTopRight(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            let x = view.center.x + t.x
            let y = view.center.y + t.y
            
            switch self.scaleRatio {
            case .free:
                let w = x - (self.maxScope.width + self.Grid.frame.origin.x)
                let max_w = w + self.maxScope.width
                let max_h = Grid.frame.height - (y - Grid.frame.origin.y)
                
                if x <= maxScope.maxX && max_w >= self.minimumCrop {
                    view.center.x = x
                    self.Grid.frame.size.width = max_w
                }
                
                if y >= self.maxScope.origin.y && max_h >= self.minimumCrop {
                    view.center.y = y
                    self.Grid.frame.origin.y = y
                    self.Grid.frame.size.height = max_h
                }
            default:
                let w = x - (self.maxScope.width + self.Grid.frame.origin.x)
                let width = w + self.maxScope.width
                
                if ratio.height >= ratio.width {
                    let height = width * ratioCalculate
                    let y = self.Grid.frame.maxY - height
                    
                    if y >= self.maxScope.origin.y && x >= maxScope.origin.x && x <= maxScope.maxX && height >= self.minimumCrop && width >= self.minimumCrop {
                        
                        view.center.x = x
                        self.Grid.frame.origin.y = y
                        self.Grid.frame.size.width = width
                        self.Grid.frame.size.height = height
                    }
                } else {
                    let height = width / ratioCalculate
                    let y = self.Grid.frame.maxY - height
                    
                    if y >= self.maxScope.origin.y && x >= maxScope.origin.x && x <= maxScope.maxX && height >= self.minimumCrop && width >= self.minimumCrop {
                        view.center.x = x
                        self.Grid.frame.origin.y = y
                        self.Grid.frame.size.width = width
                        self.Grid.frame.size.height = height
                    }
                    
                }
                
                
                
                break
            }
            
            
            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
    
    @objc internal func moveBottomLeft(_ sender: UIPanGestureRecognizer) {
        let t = sender.translation(in: self.view)
        if let view = sender.view {
            
            let x = view.center.x + t.x
            let y = view.center.y + t.y
            
            
            
            switch self.scaleRatio {
            case .free:
                let width = Grid.frame.width - (x - Grid.frame.origin.x)
                let height = y - Grid.frame.origin.y
                
                if x >= self.maxScope.origin.x && width >= self.minimumCrop {
                    view.center.x = x
                    self.Grid.frame.origin.x = x
                    self.Grid.frame.size.width = width
                }
                
                if y <= self.maxScope.maxY && height >= self.minimumCrop {
                    view.center.y = y
                    self.Grid.frame.size.height = height
                }
                
                break
            default:
                let width = Grid.frame.width - (x - Grid.frame.origin.x)
                
                
                if ratio.height >= ratio.width {
                    let height = width * ratioCalculate
                    let max_y =  height + Grid.frame.origin.y
                    
                    if x >= self.maxScope.origin.x && max_y <= maxScope.maxY && width >= self.minimumCrop && height >= self.minimumCrop {
                        view.center.x = x
                        self.Grid.frame.origin.x = x
                        self.Grid.frame.size.width = width
                        self.Grid.frame.size.height = height
                    }
                } else {
                    let height = width / ratioCalculate
                    let max_y =  height + Grid.frame.origin.y
                    
                    if x >= self.maxScope.origin.x && max_y <= maxScope.maxY && width >= self.minimumCrop && height >= self.minimumCrop {
                        view.center.x = x
                        self.Grid.frame.origin.x = x
                        self.Grid.frame.size.width = width
                        self.Grid.frame.size.height = height
                    }
                }
            }
            
            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
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
                
                if x <= self.maxScope.maxX && w >= self.minimumCrop {
                    view.center.x = x
                    self.Grid.frame.size.width = w
                }
                
                if y <= self.maxScope.maxY && h >= self.minimumCrop {
                    view.center.y = y
                    self.Grid.frame.size.height = h
                }
                
            default:
                
                if ratio.height >= ratio.width {
                    let multi = w * ratioCalculate
                    let max_y =  multi + Grid.frame.origin.y
                    if max_y <= maxScope.maxY && x <= maxScope.maxX && w >= self.minimumCrop && h >= self.minimumCrop  {
                        view.center.x = x
                        self.Grid.frame.size.width = w
                        self.Grid.frame.size.height = multi
                    }
                } else {
                    let multi = w / ratioCalculate
                    let max_y =  multi + Grid.frame.origin.y
                    if max_y <= maxScope.maxY && x <= maxScope.maxX && w >= self.minimumCrop && h >= self.minimumCrop {
                        view.center.x = x
                        self.Grid.frame.size.width = w
                        self.Grid.frame.size.height = multi
                    }
                }
                
            }
            
            self.Grid.updateContent()
            self.updateMargin()
            self.bgview.DimmingOverlay(alpha: 0.7, rect: self.Grid.frame)
            
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
    
    func getframe() -> CGRect {
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
        return r
    }
    
    func setFrameForOverlay() {
        var r:CGRect = .zero
        if let s = image?.size {
            
            let c = s.width / s.height
            let h = (self.frame.width / 2) / c
            let y = (self.frame.height / 2) - (h / 2) + self.frame.origin.y
            
            if h > (self.frame.height / 2) {
                let c = s.height / s.width
                let w = (self.frame.height / 2) / c
                let x = (self.frame.width / 2) - (w / 2) + self.frame.origin.x
                r = .init(x: x, y: self.frame.origin.y, width: w, height: self.frame.height)
            } else {
                r = .init(x: self.frame.origin.x, y: y, width: self.frame.width, height: h)
            }
        }
        self.frame = r
    }
    
    
    
    func calculetorImageFrame(frame:CGRect = .zero) -> CGRect {
        var r:CGRect = .zero
        if let s = image?.size {
            
            let c = s.width / s.height
            let h = frame.width / c
            let y = (frame.height / 2) - (h / 2) + frame.origin.y
            
            if h > frame.height {
                let c = s.height / s.width
                let w = frame.height / c
                let x = (frame.width / 2) - (w / 2) + frame.origin.x
                r = .init(x: x, y: frame.origin.y, width: w, height: frame.height)
            } else {
                r = .init(x: frame.origin.x, y: y, width: frame.width, height: h)
            }
        }
        return r
    }
}

