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
        guard let image = image else {return}
        let angel = (degree * .pi) / 180
        let ciimage = CIImage(image: image)
        guard let StraightenFilter = ciimage?.applyingFilter("CIStraightenFilter", parameters: ["inputAngle":NSNumber(value: angel)]) else {return}
        self.imageview.image = UIImage(ciImage: StraightenFilter, scale: 0.1, orientation: .up)
    }
    
    //scrollview delegate
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageview
    }
    
}
