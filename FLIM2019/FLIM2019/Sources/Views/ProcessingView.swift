//
//  ProcessingView.swift
//  FLIM2019
//
//  Created by chaloemphong on 21/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
import UIKit

open class ProcessingView: UIView {
    
    class var shared: ProcessingView {
        struct Static {
            static let instance: ProcessingView = ProcessingView()
        }
        return Static.instance
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    func initialize(view: UIView) {
        self.frame = view.frame
        
        let imageView = UIImageView()
        self.imageView = imageView
        self.imageView.frame.size = .init(width: 105, height: 276)
        self.imageView.image = UIImage(named: "processing.png")
        self.imageView.layer.compositingFilter = "screenBlendMode"
        self.imageView.center = view.center
        self.alpha = 0
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(self.imageView)
        self.bringSubviewToFront(view)
        view.addSubview(self)
    }
    
    func show() {
        self.alpha = 1
    }
    
    func hind() {
        self.alpha = 0
    }
}
