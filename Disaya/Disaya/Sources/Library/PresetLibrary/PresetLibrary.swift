//
//  PresetLibrary.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class PresetLibrary {
    
    func filter(indexPath: IndexPath, ciimage:CIImage?) -> CIImage? {
       
        switch indexPath {
        case IndexPath(item: 0, section: 1):
            return CIPhotoEffectChrome(ciimage: ciimage)
        case IndexPath(item: 1, section: 1):
            return CIPhotoEffectFade(ciimage: ciimage)
        case IndexPath(item: 2, section: 1):
            return CIPhotoEffectInstant(ciimage: ciimage)
        case IndexPath(item: 3, section: 1):
            return CIPhotoEffectTransfer(ciimage: ciimage)
        case IndexPath(item: 4, section: 1):
            return CIPhotoEffectMono(ciimage: ciimage)
        case IndexPath(item: 5, section: 1):
            return P5(ciimage: ciimage)
        case IndexPath(item: 6, section: 1):
            return P6(ciimage: ciimage)
        case IndexPath(item: 0, section: 2):
            return P7(ciimage: ciimage)
        case IndexPath(item: 1, section: 2):
            return P8(ciimage: ciimage)
        case IndexPath(item: 2, section: 2):
            return P9(ciimage: ciimage)
        case IndexPath(item: 3, section: 2):
            return P10(ciimage: ciimage)
        case IndexPath(item: 4, section: 2):
            return P11(ciimage: ciimage)
        case IndexPath(item: 5, section: 2):
            return P12(ciimage: ciimage)
        case IndexPath(item: 6, section: 2):
            return P13(ciimage: ciimage)
        default: return ciimage
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
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0.15), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.2, y: 0.25), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.45, y: 0.55), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.78), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
        let ColorPolynomial = CIFilter(name: "CIColorPolynomial")
        
        let red = CIVector(x: -0.05, y: 1.25, z: 0, w: 0.05)
        ColorPolynomial?.setDefaults()
        ColorPolynomial?.setValue(ToneCurve!.outputImage!, forKey: kCIInputImageKey)
        ColorPolynomial?.setValue(red, forKey: "inputRedCoefficients")
        return ColorPolynomial?.outputImage
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
    
    func P12(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0.15), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.25, y: 0.3), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.49, y: 0.51), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.75), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
        let ColorPolynomial = CIFilter(name: "CIColorPolynomial")
        
        let red = CIVector(x: -0.05, y: 1.25, z: 0, w: 0.05)
        ColorPolynomial?.setDefaults()
        ColorPolynomial?.setValue(ToneCurve!.outputImage!, forKey: kCIInputImageKey)
        ColorPolynomial?.setValue(red, forKey: "inputRedCoefficients")
        
        let p = self.CIPhotoEffectChrome(ciimage: ColorPolynomial?.outputImage!)
        return p
    }
    
    func P13(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.3602985143661499, inputHighlightAmount: 0.68217909336090088)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 0.85611945390701294, inputContrast: 1.0223881006240845)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 6089.40283203125, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp!
        multi.inputOrangeShift = .init(x: -0.018059698864817619, y: 1.090746283531189, z: 1)
        multi.inputGreenShift = .init(x: -0.20029851794242859,  y: 1.2623881101608276, z: 1)
        multi.inputYellowShift = .init(x: -0.094179101288318634, y: 1.0322387218475342, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: -0.35820895433425903)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.12507465481758118)
        let grain = self.Grain(value: 0.34268656373023987, buttom: Sharp!)
        
        return grain
    }
    
    func P5(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.25, y: 0.3), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.49, y: 0.51), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.75), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1.1, y: 1), forKey: "inputPoint4")
        
        let ColorPolynomial = CIFilter(name: "CIColorPolynomial")
        
        let red = CIVector(x: -0.05, y: 1.25, z: 0, w: 0.05)
        let green = CIVector(x: 0, y: 1.2, z: 0, w: 0)
        ColorPolynomial?.setDefaults()
        ColorPolynomial?.setValue(ToneCurve!.outputImage!, forKey: kCIInputImageKey)
        ColorPolynomial?.setValue(red, forKey: "inputRedCoefficients")
        ColorPolynomial?.setValue(green, forKey: "inputGreenCoefficients")
        
        
        let p = self.CIPhotoEffectChrome(ciimage: ColorPolynomial?.outputImage!)
        return p
    }
    
    func GrainGenerator(size:CGSize) -> CIImage? {
        var newsize = size
        if newsize.width > 1500 || newsize.height > 1500 {
            newsize = CGSize.init(width: size.width * 0.6, height: size.height * 0.6)
        }
        let s = CIVector.init(x: 0, y: 0, z: newsize.width, w: newsize.height)
        let grain = CIFilter.init(name: "CIRandomGenerator")?.outputImage
        let crop = CIFilter.init(name: "CICrop")
        crop?.setValue(grain!, forKey: kCIInputImageKey)
        crop?.setValue(s, forKey: "inputRectangle")
        let mono = crop?.outputImage?.applyingFilter("CIPhotoEffectMono", parameters: [:])
        return mono
    }
    
    func Grain(value:CGFloat, buttom ciimage:CIImage) -> CIImage? {
        if value == 0 {
            return ciimage
        }
        
        let b = UIImage(ciImage: ciimage)
        if let g = self.GrainGenerator(size: ciimage.extent.size) {
            let img = self.Merge(top: UIImage(ciImage: g), buttom: b, alpha: value, blandMode: .overlay)
            return CIImage(image: img!)
        }
        return ciimage
    }
    
    func Merge(top:UIImage, buttom:UIImage, alpha:CGFloat, blandMode:CGBlendMode) -> UIImage? {
        if alpha == 0 {
            return buttom
        }
        
        let size = buttom.size
        UIGraphicsBeginImageContext(size)
        let area = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        buttom.draw(in: area)
        top.draw(in: area, blendMode: blandMode, alpha: alpha)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
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
    
    // Toos
    func bloom(inputImage: CIImage?, inputRadius: NSNumber, inputIntensity: NSNumber = 0.5) -> CIImage? {
        guard let ciimage = inputImage else {return nil}
        let convert = UIImage(ciImage: ciimage)
        
        let bloom = CIFilter(name: "CIBloom")
        bloom?.setDefaults()
        bloom?.setValue(ciimage, forKey: kCIInputImageKey)
        bloom?.setValue(inputRadius, forKey: "inputRadius")
        bloom?.setValue(inputIntensity, forKey: "inputIntensity")
        
        let crop = bloom?.outputImage?.cropped(to: .init(x: 0, y: 0, width: convert.size.width, height: convert.size.height))
        return crop
    }
    
    func colorControls(inputImage: CIImage, inputSaturation: NSNumber = 1, inputBrightness: NSNumber = 0, inputContrast: NSNumber = 1) -> CIImage? {
        guard let filter = CIFilter(name: "CIColorControls") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputSaturation, forKey: "inputSaturation")
        filter.setValue(inputBrightness, forKey: kCIInputBrightnessKey)
        filter.setValue(inputContrast, forKey: kCIInputContrastKey)
        return filter.outputImage
    }
    
    
    func whitePoint(ciimage:CIImage? ,point: CGFloat) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let color = CIColor(red: 1, green: 1, blue: 1, alpha: point)
        let filter = CIFilter(name: "CIWhitePointAdjust")
        filter?.setValue(ciimage, forKey: "inputImage")
        filter?.setValue(color, forKey: "inputColor")
        return filter?.outputImage
    }
    
    func exposureAdjust(inputImage: CIImage, inputEV: NSNumber = 0) -> CIImage? {
        guard let filter = CIFilter(name: "CIExposureAdjust") else {
            return nil
        }
        //        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputEV, forKey: kCIInputEVKey)
        return filter.outputImage
    }
    
    func gammaAdjust(inputImage: CIImage, inputPower: NSNumber = 1) -> CIImage? {
        guard let filter = CIFilter(name: "CIGammaAdjust") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputPower, forKey: "inputPower")
        return filter.outputImage
    }
    
    func temperatureAndTint(inputImage: CIImage, inputNeutral: CIVector = CIVector(x: 6500.0, y: 0.0), inputTargetNeutral: CIVector = CIVector(x: 6500.0, y: 0.0)) -> CIImage? {
        guard let filter = CIFilter(name: "CITemperatureAndTint") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputNeutral, forKey: "inputNeutral")
        filter.setValue(inputTargetNeutral, forKey: "inputTargetNeutral")
        return filter.outputImage
    }
    
    func highlightShadowAdjust(inputImage: CIImage, inputRadius: NSNumber = 0, inputShadowAmount: NSNumber = 0, inputHighlightAmount: NSNumber = 1) -> CIImage? {
        guard let filter = CIFilter(name: "CIHighlightShadowAdjust") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputRadius, forKey: kCIInputRadiusKey)
        filter.setValue(inputShadowAmount, forKey: "inputShadowAmount")
        filter.setValue(inputHighlightAmount, forKey: "inputHighlightAmount")
        return filter.outputImage
    }
    
    func vibrance(inputImage: CIImage, inputAmount: NSNumber = 0) -> CIImage? {
        guard let filter = CIFilter(name: "CIVibrance") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputAmount, forKey: "inputAmount")
        return filter.outputImage
    }
    
    func sharpenLuminance(inputImage: CIImage, inputSharpness: NSNumber = 0.4, inputRadius: NSNumber = 1.69) -> CIImage? {
        guard let filter = CIFilter(name: "CISharpenLuminance") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputSharpness, forKey: kCIInputSharpnessKey)
        filter.setValue(inputRadius, forKey: kCIInputRadiusKey)
        return filter.outputImage
    }
}


extension CIImage {
    public var context:CIContext? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        
        return CIContext.init(mtlDevice: device)
    }
    
    func clear() {
        self.context?.clearCaches()
    }
    
    public var RanderImage:UIImage? {
        if let r = self.context?.createCGImage(self, from: self.extent) {
            self.clear()
            return UIImage(cgImage: r)
        }
        return nil
    }
}

