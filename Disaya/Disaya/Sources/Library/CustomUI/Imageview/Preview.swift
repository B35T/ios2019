//
//  Preview.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class Preview: UIView {
    
    @IBOutlet open weak var topView: UIImageView!
    @IBOutlet open weak var bommView: UIImageView!
    
    var saveRect: CGRect = .zero
    var image: UIImage? {
        didSet {
            self.topView.image = self.image
            self.bommView.image = self.image
        }
    }
    
    var top: UIImage? {
        didSet {
            self.topView.image = self.top
        }
    }
    
    var bottom: UIImage? {
        didSet {
            self.bommView.image = self.bottom
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initailize()
        
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scale(from: CGFloat = 0, persen:CGFloat = 100, duration: TimeInterval = 0, y:CGFloat = 0) {
        UIView.animate(withDuration: duration) {
            self.frame.size.height = from / 100 * persen
            self.frame.origin.y = y
            self.topView.frame.size = self.frame.size
            self.bommView.frame.size = self.frame.size
            
        }
    }
    
    func scale(h: CGFloat = 0, minus: CGFloat = 0, y:CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = y
            self.frame.size.height = h - minus
            self.topView.frame.size = self.frame.size
            self.bommView.frame.size = self.frame.size
        }
    }
    
    func initailize() {
        let bommView = UIImageView()
        self.bommView = bommView
        self.bommView.frame.size = self.frame.size
        self.bommView.clipsToBounds = true
        self.bommView.contentMode = .scaleAspectFit
        self.addSubview(self.bommView)
        
        let topView = UIImageView()
        self.topView = topView
        self.topView.frame.size = self.frame.size
        self.topView.clipsToBounds = true
        self.topView.contentMode = .scaleAspectFit
        self.addSubview(self.topView)
    }
    
    open func animation(point: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.frame.origin = point
        }
    }
}
