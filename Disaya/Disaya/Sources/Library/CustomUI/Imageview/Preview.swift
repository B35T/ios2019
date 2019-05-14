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
    
    func initailize() {
        let topView = UIImageView()
        self.topView = topView
        self.topView.frame.size = self.frame.size
        self.topView.clipsToBounds = true
        self.topView.contentMode = .scaleAspectFit
        self.addSubview(self.topView)
        
        let bommView = UIImageView()
        self.bommView = bommView
        self.bommView.frame.size = self.frame.size
        self.bommView.clipsToBounds = true
        self.bommView.contentMode = .scaleAspectFit
        self.addSubview(self.bommView)
    }
    
    open func animation(point: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.frame.origin = point
        }
    }
}
