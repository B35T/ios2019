//
//  ShowScale.swift
//  Disaya
//
//  Created by chaloemphong on 17/6/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public class ShowScaleOverlay {
    
    var overlayView = UIView()
    private var label = UILabel()
    
    
    class var shared: ShowScaleOverlay {
        struct Static {
            static let instance: ShowScaleOverlay = ShowScaleOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView, text:String?) {
        self.overlayView.frame.size = .init(width: 60, height: 60)
        self.overlayView.frame.origin.y = view.frame.height - 230
        self.overlayView.center.x = view.center.x
        self.overlayView.alpha = 1
        self.overlayView.layer.cornerRadius = 30
        self.overlayView.backgroundColor = yellow
        view.addSubview(self.overlayView)
        
        self.label.frame = .init(x: 0, y: 0, width: overlayView.frame.width, height: 60)
        self.label.textColor = black
        self.label.text = text
        self.label.font = UIFont.boldSystemFont(ofSize: 22)
        self.label.textAlignment = .center
        self.overlayView.addSubview(self.label)
        
        
        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
            self.overlayView.alpha = 0
        }, completion: nil)
        
    }
}
