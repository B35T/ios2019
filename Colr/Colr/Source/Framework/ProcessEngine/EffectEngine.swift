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
            return CIPhotoEffectMono(ciimage: ciimage)
        case .P5:
            return CIPhotoEffectNoir(ciimage: ciimage)
        case .P6:
            return P6(ciimage: ciimage)
        case .P7:
            return P7(ciimage: ciimage)
        }
    }
    
    func blend(mode:CGBlendMode = CGBlendMode.colorDodge, alpha:CGFloat = 1, top:UIImage, bottom: UIImage) -> CIImage? {
        let size = bottom.size
        UIGraphicsBeginImageContext(size)
        let area = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        bottom.draw(in: area)
        top.draw(in: area, blendMode: mode, alpha: alpha)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return CIImage(image: result!)
    }
    
    func P6(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let c = colorControls(inputImage: ciimage, inputSaturation: 1.4, inputContrast: 1.03)
        let p = CIColorPolynomial(ciimage: c, r: .init(x: 0, y: 1.2, z: 0, w: 0), g: .init(x: 0, y: 1.25, z: 0.13, w: -0.2))
        return p
    }
    
    func P7(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let c = colorControls(inputImage: ciimage, inputSaturation: 1.2,inputBrightness: 0.01, inputContrast: 1.03)
        let m = CIColorMatrix(ciimage: c, r: .init(x: 0.85, y: -0.08595, z: 0, w: -0.014),a: .init(x: 0, y: 0, z: 0, w: 1.1))
        return m
    }
    
    func CIColorMatrix(ciimage: CIImage?, r:CIVector = CIVector(x: 1, y: 0, z: 0, w: 0), g:CIVector = CIVector(x: 0, y: 1, z: 0, w: 0), b:CIVector = CIVector(x: 0, y: 0, z: 1, w: 0), a:CIVector = CIVector(x: 0, y: 0, z: 0, w: 1)) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let filter = CIFilter(name: "CIColorMatrix")
        filter?.setDefaults()
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(r, forKey: "inputRVector")
        filter?.setValue(g, forKey: "inputGVector")
        filter?.setValue(b, forKey: "inputBVector")
        filter?.setValue(a, forKey: "inputAVector")
        return filter?.outputImage
    }
    
    func CIColorPolynomial(ciimage: CIImage?, r:CIVector = CIVector(x: 0, y: 1, z: 0, w: 0), g:CIVector = CIVector(x: 0, y: 1, z: 0, w: 0), b:CIVector = CIVector(x: 0, y: 1, z: 0, w: 0), a:CIVector = CIVector(x: 0, y: 1, z: 0, w: 0)) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let filter = CIFilter(name: "CIColorPolynomial")
        filter?.setDefaults()
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(r, forKey: "inputRedCoefficients")
        filter?.setValue(g, forKey: "inputGreenCoefficients")
        filter?.setValue(b, forKey: "inputBlueCoefficients")
        filter?.setValue(a, forKey: "inputAlphaCoefficients")
        return filter?.outputImage
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
