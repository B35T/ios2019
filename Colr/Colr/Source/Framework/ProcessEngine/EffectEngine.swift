//
//  EffectEngine.swift
//  Colr
//
//  Created by chaloemphong on 16/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension ProcessEngine {
    
    func filter(index: Int, ciimage:CIImage?) -> CIImage? {
        let f = Filter(rawValue: index)
        switch f! {
        case .P0:
            return CIPhotoEffectChrome(ciimage: ciimage)
        case .P1:
            return CIPhotoEffectFade(ciimage: ciimage)
        case .P2:
            return CIPhotoEffectInstant(ciimage: ciimage)
        case .P3:
            return CIPhotoEffectTransfer(ciimage: ciimage)
        case .P4:
            return CIPhotoEffectNoir(ciimage: ciimage)
        case .P5:
            return CIPhotoEffectMono(ciimage: ciimage)
        }
    }
    
    func ColorCrossPolynomial(ciimage: CIImage?, r:CGFloat = 1, g:CGFloat = 1, b:CGFloat = 1) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let r = CIVector(values: [r,0,0,0,0,0,0,0], count: 8)
        let g = CIVector(values: [0,g,0,0,0,0,0,0], count: 8)
        let b = CIVector(values: [0,0,b,0,0,0,0,0], count: 8)
        let filter = CIFilter(name: "CIColorCrossPolynomial")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(r , forKey: "inputRedCoefficients")
        filter?.setValue(g, forKey: "inputGreenCoefficients")
        filter?.setValue(b, forKey: "inputBlueCoefficients")
        return filter?.outputImage
    }
    
    func CIPhotoEffectChrome(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectChrome")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }
    
    func CIPhotoEffectFade(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectFade")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }

    func CIPhotoEffectInstant(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectInstant")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }

    
    func CIPhotoEffectMono(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }
    
    func CIPhotoEffectNoir(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }
    
    func CIPhotoEffectTransfer(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let filter = CIFilter(name: "CIPhotoEffectTransfer")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        return filter?.outputImage
    }
}
