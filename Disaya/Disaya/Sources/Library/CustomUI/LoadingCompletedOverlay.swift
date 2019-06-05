//
//  LoadingCompletedOverlay.swift
//  Disaya
//
//  Created by chaloemphong on 31/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public class SaveCompletedOverlay {
    
    var overlayView = UIView()
    private var label = UILabel()
    
    
    class var shared: SaveCompletedOverlay {
        struct Static {
            static let instance: SaveCompletedOverlay = SaveCompletedOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        self.overlayView.frame.size = .init(width: view.frame.width - 50, height: 50)
        self.overlayView.center.x = view.center.x
        self.overlayView.center.y = view.center.y - 50
        self.overlayView.backgroundColor = .white
        self.overlayView.alpha = 1
        self.overlayView.layer.cornerRadius = 2
        view.addSubview(self.overlayView)
        
        self.label.frame = .init(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        self.label.textColor = .black
        self.label.text = "Save To CameraRoll Finish"
        self.label.font = UIFont.boldSystemFont(ofSize: 13)
        self.label.textAlignment = .center
        self.overlayView.addSubview(self.label)
   
        
        UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
            self.overlayView.alpha = 0
        }, completion: nil)
        
    }
}

