//
//  LoadingCompletedOverlay.swift
//  Disaya
//
//  Created by chaloemphong on 31/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public class LoadingOverlay {
    
    var overlayView = UIView()
    private var label = UILabel()
    private var line = CALayer()
    
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        self.overlayView.frame.size = .init(width: view.frame.width - 30, height: 50)
        self.overlayView.center = view.center
        self.overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.overlayView.alpha = 1
        view.addSubview(self.overlayView)
        
        self.label.frame = .init(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        self.label.textColor = .white
        self.label.text = "Save Finish"
        self.label.font = UIFont.systemFont(ofSize: 14)
        self.label.textAlignment = .center
        self.overlayView.addSubview(self.label)
        
        self.line.frame = .init(x: 0, y: 0, width: overlayView.frame.width, height: 1)
        self.line.backgroundColor = UIColor.white.cgColor
        self.overlayView.layer.addSublayer(self.line)
        
        UIView.animate(withDuration: 0.3, delay: 2, options: .curveLinear, animations: {
            self.overlayView.alpha = 0
        }, completion: nil)
        
    }
}

