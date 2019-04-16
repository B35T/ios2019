//
//  ToolEngine.swift
//  Colr
//
//  Created by chaloemphong on 16/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Foundation
import CoreImage


extension ProcessEngine {
    func whitePoint(ciimage:CIImage? ,point: CGFloat) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let color = CIColor(red: 1, green: 1, blue: 1, alpha: point)
        let filter = CIFilter(name: "CIWhitePointAdjust")
        filter?.setValue(ciimage, forKey: "inputImage")
        filter?.setValue(color, forKey: "inputColor")
        return filter?.outputImage
    }
}
