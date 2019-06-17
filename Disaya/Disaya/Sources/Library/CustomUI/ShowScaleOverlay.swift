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
        self.overlayView.frame.size = .init(width: view.frame.width / 2 - 20, height: 70)
        self.overlayView.center.x = view.center.x
        self.overlayView.center.y = view.center.y - 50
        self.overlayView.alpha = 1
        self.overlayView.layer.cornerRadius = 35
        view.addSubview(self.overlayView)
        
        self.label.frame = .init(x: 0, y: 0, width: overlayView.frame.width, height: 70)
        self.label.textColor = .white
        self.label.text = text
        self.label.font = UIFont.boldSystemFont(ofSize: 36)
        self.label.textAlignment = .center
        self.overlayView.addSubview(self.label)
        
        
        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
            self.overlayView.alpha = 0
        }, completion: nil)
        
    }
}
