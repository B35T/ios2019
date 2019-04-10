//
//  Rotation.swift
//  CropImage2019
//
//  Created by chaloemphong on 8/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension imageScrollView: UIScrollViewDelegate {
    
    func rotation(degree: Float = 0.0) {
        self.imageview.transform = CGAffineTransform(rotationAngle: CGFloat(degree * .pi) / 180)
//        self.imageview.center  = self.center
        self.scrollview.backgroundColor = .red
        self.scrollview.zoomScale = 1.2
    }
    
    //scrollview delegate
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageview
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView.zoomScale > 1 {
            
            if let image = self.imageview.image {
                
                let ratioW = self.imageview.frame.width / image.size.width
                let ratioH = self.imageview.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW:ratioH
                
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio
                
                let left = 0.5 * (newWidth * scrollView.zoomScale > self.imageview.frame.width ? (newWidth - self.imageview.frame.width) : (scrollview.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > self.imageview.frame.height ? (newHeight - self.imageview.frame.height) : (scrollview.frame.height - scrollview.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
                print(scrollView.contentInset)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
}

extension CGFloat {
    
    var half: CGFloat {
        return self / 2.0
    }
    
    static var zero: CGFloat {
        return 0.0
    }
}
