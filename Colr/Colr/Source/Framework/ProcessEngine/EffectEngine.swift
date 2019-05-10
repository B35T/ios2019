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
        case .P8:
            return P8(ciimage: ciimage)
        case .P9:
            return P9(ciimage: ciimage)
        case .P10:
            return P10(ciimage: ciimage)
        case .P11:
            return P11(ciimage: ciimage)
        }
    }
    
    func scaleFilter(_ input:CIImage, aspectRatio : Double, scale : Double) -> CIImage {
        let scaleFilter = CIFilter(name:"CILanczosScaleTransform")!
        scaleFilter.setValue(input, forKey: kCIInputImageKey)
        scaleFilter.setValue(scale, forKey: kCIInputScaleKey)
        scaleFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        return scaleFilter.outputImage!
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
        let c = colorControls(inputImage: ciimage, inputSaturation: 1, inputContrast: 1.03)
        
        let multi = MultiBandHSV()
        multi.inputImage = c
        multi.inputOrangeShift = .init(x: 0.01, y: 1.02, z: 1)
        multi.inputGreenShift = .init(x: -0.10,  y: 1.1, z: 0.95)
        multi.inputYellowShift = .init(x: -0.10, y: 1.1, z: 0.95)
        multi.inputBlueShift = .init(x: -0.03, y: 1.3, z: 1)
        multi.inputAquaShift = .init(x: -0.03, y: 1.3, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        return multi.outputImage
    }
    
    func P7(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let c = colorControls(inputImage: ciimage, inputSaturation: 1.2,inputBrightness: 0.01, inputContrast: 1.03)
        let m = CIColorMatrix(ciimage: c, r: .init(x: 0.85, y: -0.08595, z: 0, w: -0.014),a: .init(x: 0, y: 0, z: 0, w: 1.1))
        return m
    }
    
    func P8(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let convert = UIImage(ciImage: ciimage)
        
        let bloom = CIFilter(name: "CIBloom")
        bloom?.setDefaults()
        bloom?.setValue(ciimage, forKey: kCIInputImageKey)
        bloom?.setValue(10, forKey: "inputRadius")
        bloom?.setValue(1, forKey: "inputIntensity")
        
        let crop = bloom?.outputImage?.cropped(to: .init(x: 0, y: 0, width: convert.size.width, height: convert.size.height))
        return crop
    }
    
    func P9(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.005, y: 1.02, z: 1)
        multi.inputGreenShift = .init(x: 0.04,  y: 1, z: 1)
        multi.inputYellowShift = .init(x: -0.03, y: 1, z: 1)
        multi.inputBlueShift = .init(x: -0.010, y: 1.1, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        
        let c = colorControls(inputImage: multi.outputImage!, inputSaturation: 0.9,inputBrightness: 0, inputContrast: 1.03)
        let m = CIColorMatrix(ciimage: c, r: .init(x: 0.85, y: -0.08595, z: 0, w: -0.014),a: .init(x: 0, y: 0, z: 0, w: 1.1))
       
        return m
    }
    
    func P10(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
//        let e = self.exposureAdjust(inputImage: ciimage, inputEV: -0.1)
        let p = self.CIPhotoEffectChrome(ciimage: ciimage)
        let multi = MultiBandHSV()
        multi.inputImage = p
        multi.inputOrangeShift = .init(x: 0.01, y: 1.02, z: 1)
        multi.inputGreenShift = .init(x: 0.05,  y: 1, z: 1)
        multi.inputYellowShift = .init(x: 0.05, y: 1, z: 1)
        multi.inputBlueShift = .init(x: -0.03, y: 1.2, z: 1)
        multi.inputAquaShift = .init(x: -0.03, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        let c = colorControls(inputImage: multi.outputImage!, inputSaturation: 0.9,inputBrightness: 0.01, inputContrast: 1.02)
        return c
    }
    
    func P11(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let fade = self.CIPhotoEffectFade(ciimage: ciimage)
        let multi = MultiBandHSV()
        multi.inputImage = fade
        multi.inputOrangeShift = .init(x: 0.01, y: 1.02, z: 1)
        multi.inputGreenShift = .init(x: -0.10,  y: 1.1, z: 0.95)
        multi.inputYellowShift = .init(x: -0.10, y: 1.1, z: 0.95)
        multi.inputBlueShift = .init(x: -0.03, y: 1.3, z: 1)
        multi.inputAquaShift = .init(x: -0.03, y: 1.3, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        return multi.outputImage
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
