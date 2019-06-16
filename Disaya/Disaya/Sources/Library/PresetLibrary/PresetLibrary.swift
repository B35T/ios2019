//
//  PresetLibrary.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class PresetLibrary {
    
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
            return S5(ciimage: ciimage)
        case IndexPath(item: 6, section: 1):
            return S6(ciimage: ciimage)
        case IndexPath(item: 0, section: 2):
            return P0(ciimage: ciimage)
        case IndexPath(item: 1, section: 2):
            return P1(ciimage: ciimage)
        case IndexPath(item: 2, section: 2):
            return P2(ciimage: ciimage)
        case IndexPath(item: 3, section: 2):
            return P3(ciimage: ciimage)
        case IndexPath(item: 4, section: 2):
            return P4(ciimage: ciimage)
        case IndexPath(item: 5, section: 2):
            return P5(ciimage: ciimage)
        case IndexPath(item: 6, section: 2):
            return P6(ciimage: ciimage)
        case IndexPath(item: 0, section: 3):
            return G0(ciimage: ciimage)
        case IndexPath(item: 1, section: 3):
            return G1(ciimage: ciimage)
        case IndexPath(item: 2, section: 3):
            return G2(ciimage: ciimage)
        case IndexPath(item: 3, section: 3):
            return G3(ciimage: ciimage)
        case IndexPath(item: 4, section: 3):
            return G4(ciimage: ciimage)
        case IndexPath(item: 5, section: 3):
            return G5(ciimage: ciimage)
        case IndexPath(item: 6, section: 3):
            return G6(ciimage: ciimage)
            //
        case IndexPath(item: 7, section: 3):
            return C9(ciimage: ciimage)
            //
        case IndexPath(item: 0, section: 4):
            return C0(ciimage: ciimage)
        case IndexPath(item: 1, section: 4):
            return C1(ciimage: ciimage)
        case IndexPath(item: 2, section: 4):
            return C2(ciimage: ciimage)
        case IndexPath(item: 3, section: 4):
            return C3(ciimage: ciimage)
        case IndexPath(item: 4, section: 4):
            return C4(ciimage: ciimage)
        case IndexPath(item: 5, section: 4):
            return C5(ciimage: ciimage)
        case IndexPath(item: 6, section: 4):
            return C6(ciimage: ciimage)
        case IndexPath(item: 7, section: 4):
            return C7(ciimage: ciimage)
        case IndexPath(item: 8, section: 4):
            return C8(ciimage: ciimage)
        
        case IndexPath(item: 0, section: 5):
            return RB0(ciimage: ciimage)
        case IndexPath(item: 1, section: 5):
            return RB1(ciimage: ciimage)
        case IndexPath(item: 0, section: 6):
            return M0(ciimage: ciimage)
        case IndexPath(item: 1, section: 6):
            return M1(ciimage: ciimage)
        case IndexPath(item: 2, section: 6):
            return M2(ciimage: ciimage)
        case IndexPath(item: 3, section: 6):
            return M3(ciimage: ciimage)
        
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
    
    func S5(ciimage: CIImage?) -> CIImage? {
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
    
    func S6(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let c3 = self.C3(ciimage: ciimage)
        
        let multi = MultiBandHSV()
        multi.inputImage = c3
        multi.inputGreenShift = .init(x: 0.09,  y: 0.65, z: 1)
        multi.inputYellowShift = .init(x: 0.14,  y: 0.5, z: 1)
        return multi.outputImage
    }

    func P0(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let c = colorControls(inputImage: ciimage, inputSaturation: 1.2,inputBrightness: 0.01, inputContrast: 1.03)
        let m = CIColorMatrix(ciimage: c, r: .init(x: 0.85, y: -0.08595, z: 0, w: -0.014),a: .init(x: 0, y: 0, z: 0, w: 1.1))
        return m
    }
    
    func P1(ciimage: CIImage?) -> CIImage? {
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
    
    func P2(ciimage: CIImage?) -> CIImage? {
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
    
    func P3(ciimage: CIImage?) -> CIImage? {
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
    
    func P4(ciimage:CIImage?) -> CIImage? {
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
        
        let red = CIVector(x: 0.01, y: 1.05, z: 0, w: 0.05)
        ColorPolynomial?.setDefaults()
        ColorPolynomial?.setValue(ToneCurve!.outputImage!, forKey: kCIInputImageKey)
        ColorPolynomial?.setValue(red, forKey: "inputRedCoefficients")
        
        let p = self.CIPhotoEffectChrome(ciimage: ColorPolynomial?.outputImage!)
        
        let multi = MultiBandHSV()
        multi.inputImage = p
        multi.inputOrangeShift = .init(x: 0, y: 0.8, z: 1)
        return multi.outputImage
    }
    
    func P5(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0.15), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.25, y: 0.3), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.49, y: 0.51), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.75), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
       
        let p = self.CIPhotoEffectChrome(ciimage: ToneCurve?.outputImage!)
        
        let multi = MultiBandHSV()
        multi.inputImage = p
        multi.inputOrangeShift = .init(x: 0, y: 0.8, z: 1)
        
        let H = self.highlightShadowAdjust(inputImage: multi.outputImage!, inputShadowAmount: -0.3602985143661499, inputHighlightAmount: 0.68217909336090088)
        let Temp = self.temperatureAndTint(inputImage: H!, inputNeutral: .init(x: 7500, y: 0))
        return Temp
    }
    
    
    func P6(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0.15), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.25, y: 0.3), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.49, y: 0.51), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.75), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
        
        let p = self.CIPhotoEffectChrome(ciimage: ToneCurve?.outputImage!)
        
        let multi = MultiBandHSV()
        multi.inputImage = p
        multi.inputOrangeShift = .init(x: 0, y: 0.8, z: 1)
        
        let H = self.highlightShadowAdjust(inputImage: multi.outputImage!, inputShadowAmount: -0.3602985143661499, inputHighlightAmount: 0.68217909336090088)
        let Temp = self.temperatureAndTint(inputImage: H!, inputNeutral: .init(x: 4500, y: 0))
        return Temp
    }
    
    func G0(ciimage: CIImage?) -> CIImage? {
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
//        let grain = self.Grain(value: 0.34268656373023987, buttom: Sharp!)
        
        return Sharp
    }
    
    
    func G1(ciimage: CIImage?) -> CIImage? {
    guard let ciimage = ciimage else {return nil}
    let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.3602985143661499, inputHighlightAmount: 0.68217909336090088)
    let Con = self.colorControls(inputImage: H!, inputSaturation: 0.90537309646606445, inputContrast: 1.0223881006240845)
    let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 7653.4326171875, y: 0))
    
    let multi = MultiBandHSV()
    multi.inputImage = Temp!
    multi.inputOrangeShift = .init(x: -0.018059698864817619, y: 1.1635820865631104, z: 1)
    multi.inputGreenShift = .init(x: -0.02477613091468811,  y: 1.130149245262146, z: 1)
    multi.inputYellowShift = .init(x: 0, y: 0.31283584237098694, z: 1)
    multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
    multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
    multi.inputRedShift = .init(x: 0, y: 1, z: 1)
    
    let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: -0.35820895433425903)
    let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.12507465481758118)
    
    return Sharp
    }
    
    func G2(ciimage: CIImage?) -> CIImage? {
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
    
    func G3(ciimage: CIImage?) -> CIImage? {
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
        
        let ColorPolynomial = CIFilter(name: "CIColorPolynomial")
        
        let red = CIVector(x: 0.01, y: 1.05, z: 0, w: 0.05)
        ColorPolynomial?.setDefaults()
        ColorPolynomial?.setValue(multi.outputImage!, forKey: kCIInputImageKey)
        ColorPolynomial?.setValue(red, forKey: "inputRedCoefficients")
        
        return ColorPolynomial?.outputImage
    }
    
    func G4(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.2, inputHighlightAmount: 0.8)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 0.9, inputContrast: 1.01)
        
        let multi = MultiBandHSV()
        multi.inputImage = Con
        multi.inputOrangeShift = .init(x: -0.018059698864817619, y: 1.090746283531189, z: 1)
        multi.inputGreenShift = .init(x: 0.02,  y: 1.2, z: 1)
        multi.inputYellowShift = .init(x: -0.09, y: 1.1, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.9, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 1, z: 1)
        multi.inputRedShift = .init(x: 0.01, y: 1, z: 1)
        
        let fade = self.CIPhotoEffectFade(ciimage: multi.outputImage)
        return fade
    }
    
    func G5(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let Con = self.colorControls(inputImage: ciimage, inputSaturation: 0.90537309646606445, inputContrast: 1.01)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 8000, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp
        multi.inputOrangeShift = .init(x: -0.018059698864817619, y: 1.1635820865631104, z: 1)
        multi.inputGreenShift = .init(x: -0.02477613091468811,  y: 1.130149245262146, z: 1)
        multi.inputYellowShift = .init(x: 0, y: 0.31283584237098694, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let fade = self.CIPhotoEffectFade(ciimage: multi.outputImage)
        return F19(ciimage: fade!)
    }

    // tone 16
    func G6(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.22149257361888885, inputHighlightAmount: 0.67601495981216431)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 0.85611945390701294, inputContrast: 1.0143283605575562)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 6089.40283203125, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp!
        multi.inputOrangeShift = .init(x: -0.018059698864817619, y: 1.090746283531189, z: 1)
        multi.inputGreenShift = .init(x: -0.20029851794242859,  y: 1.2623881101608276, z: 1)
        multi.inputYellowShift = .init(x: -0.094179101288318634, y: 1.0322387218475342, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: -0.012835784815251827)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.12507465481758118)
        
        return F19(ciimage: Sharp!)
    }
    
    func C0(ciimage: CIImage?) -> CIImage? {
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
        
        let H = self.highlightShadowAdjust(inputImage: ColorPolynomial!.outputImage!, inputShadowAmount: 0.10865668207406998, inputHighlightAmount: 0.9)

        let p = self.CIPhotoEffectChrome(ciimage: H)
        return p
    }
    
    func C1(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        guard let p5 = self.C0(ciimage: ciimage) else {print("no p5"); return nil}
        let H = self.highlightShadowAdjust(inputImage: p5, inputShadowAmount: 0.10865668207406998, inputHighlightAmount: 0.9766268253326416)
        let Temp2 = self.temperatureAndTint(inputImage: H!, inputNeutral: .init(x: 5773.88037109375, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp2!
        multi.inputOrangeShift = .init(x: 0, y: 0.9005969762802124, z: 1)
        multi.inputGreenShift = .init(x: -0.066119402647018405,  y: 1.0567164421081543, z: 1)
        multi.inputYellowShift = .init(x: -0.079402975738048553, y: 0.50, z: 1)
        multi.inputBlueShift = .init(x: -0.024925382807850838, y: 1.1641790866851807, z: 1)
        multi.inputAquaShift = .init(x: -0.010746262036263943, y: 1.1298507452011108, z: 1)
        multi.inputRedShift = .init(x: 0, y: 0.9005969762802124, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: 0.1262686550617218)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.15164180099964142)
//        let grain = self.Grain(value: 0.33761194348335266, buttom: Sharp!)
        return Sharp
    }
    
    func C2(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let f2 = F2(ciimage: ciimage)
        
        let H = self.highlightShadowAdjust(inputImage: f2, inputShadowAmount: 0.10865668207406998, inputHighlightAmount: 0.9)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 1, inputContrast: 1.0164179801940918)
        let Temp2 = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 5773.88037109375, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp2!
        multi.inputOrangeShift = .init(x: 0, y: 0.9005969762802124, z: 1)
        multi.inputGreenShift = .init(x: -0.066119402647018405,  y: 1.0567164421081543, z: 1)
        multi.inputYellowShift = .init(x: -0.079402975738048553, y: 1.083283543586731, z: 1)
        multi.inputBlueShift = .init(x: -0.024925382807850838, y: 1.1641790866851807, z: 1)
        multi.inputAquaShift = .init(x: -0.010746262036263943, y: 1.1298507452011108, z: 1)
        multi.inputRedShift = .init(x: 0, y: 0.9005969762802124, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: 0.25)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.15164180099964142)
        let gamma = self.gammaAdjust(inputImage: Sharp!, inputPower: 0.8)
        
        return gamma
    }
    
    func C3(ciimage: CIImage?) -> CIImage? {
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
    
    func C4(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let c = self.C3(ciimage: ciimage)
        
        let r = CIVector.init(x: 1.3, y: -0.5, z: 0, w: 0)
        let g = CIVector.init(x: -0.05, y: 0.9, z: -0.03, w: 0.02)
        let b = CIVector.init(x: 0, y: -0.2126, z: 1.312, w: 0.01)
        
        let colorMatrix = CIFilter(name: "CIColorMatrix")
        colorMatrix?.setDefaults()
        colorMatrix?.setValue(c, forKey: kCIInputImageKey)
        colorMatrix?.setValue(r, forKey: "inputRVector")
        colorMatrix?.setValue(g, forKey: "inputGVector")
        colorMatrix?.setValue(b, forKey: "inputBVector")
        
        return colorMatrix?.outputImage
    }
    
    func C5(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}

        let r = CIVector.init(x: 1.4, y: 0.2, z: -0.8, w: 0)
        let b = CIVector.init(x: -0.05, y: -0.15, z: 1.9, w: 0)
    
        let colorMatrix = CIFilter(name: "CIColorMatrix")
        colorMatrix?.setDefaults()
        colorMatrix?.setValue(ciimage, forKey: kCIInputImageKey)
        colorMatrix?.setValue(r, forKey: "inputRVector")
        colorMatrix?.setValue(b, forKey: "inputBVector")

        let h = self.highlightShadowAdjust(inputImage: colorMatrix!.outputImage!, inputShadowAmount: 0.3, inputHighlightAmount: 1)
        return self.C3(ciimage: h)
    }
    
    func C6(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let ToneCurve = CIFilter(name: "CIToneCurve")
        ToneCurve?.setDefaults()
        ToneCurve?.setValue(ciimage, forKey: kCIInputImageKey)
        ToneCurve?.setValue(CIVector(x: 0, y: 0.15), forKey: "inputPoint0")
        ToneCurve?.setValue(CIVector(x: 0.25, y: 0.3), forKey: "inputPoint1")
        ToneCurve?.setValue(CIVector(x: 0.49, y: 0.51), forKey: "inputPoint2")
        ToneCurve?.setValue(CIVector(x: 0.75, y: 0.75), forKey: "inputPoint3")
        ToneCurve?.setValue(CIVector(x: 1, y: 1), forKey: "inputPoint4")
        
        let r = CIVector.init(x: 1.3, y: -0.5, z: 0, w: 0)
        let g = CIVector.init(x: -0.05, y: 0.9, z: -0.03, w: 0.02)
        let b = CIVector.init(x: 0, y: -0.2126, z: 1.312, w: 0.01)
        
        let colorMatrix = CIFilter(name: "CIColorMatrix")
        colorMatrix?.setDefaults()
        colorMatrix?.setValue(ToneCurve!.outputImage!, forKey: kCIInputImageKey)
        colorMatrix?.setValue(r, forKey: "inputRVector")
        colorMatrix?.setValue(g, forKey: "inputGVector")
        colorMatrix?.setValue(b, forKey: "inputBVector")
        
        let Con = self.colorControls(inputImage: colorMatrix!.outputImage!, inputSaturation: 0.90537309646606445, inputContrast: 1.01)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 7000, y: 0))
        return CIPhotoEffectChrome(ciimage: Temp)
    }
    
    func C7(ciimage: CIImage?) -> CIImage? {
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
        
        let H = self.highlightShadowAdjust(inputImage: ColorPolynomial!.outputImage!, inputShadowAmount: 0.10865668207406998, inputHighlightAmount: 0.9)
        
        let c6 = self.C6(ciimage: H!)
        return c6
    }
    
    // like tone 14
    func C8(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.22149257361888885, inputHighlightAmount: 0.67601495981216431)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 0.85611945390701294, inputContrast: 1.0143283605575562)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 6089.40283203125, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp!
        multi.inputOrangeShift = .init(x: -0.030447764322161664, y: 1.1289552450180054, z: 1)
        multi.inputGreenShift = .init(x: 0.10298509150743484,  y: 1, z: 1)
        multi.inputYellowShift = .init(x: -0.021492522209882729, y: 1.0125373601913452, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1.0480597019195557, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: -0.012835784815251827)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.12507465481758118)
        
        return F19(ciimage: Sharp!)
    }
    
    // tone 11
    func C9(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let H = self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: -0.22149257361888885, inputHighlightAmount: 0.67601495981216431)
        let Con = self.colorControls(inputImage: H!, inputSaturation: 0.85611945390701294, inputContrast: 1.0143283605575562)
        let Temp = self.temperatureAndTint(inputImage: Con!, inputNeutral: .init(x: 7000, y: 0))
        
        let multi = MultiBandHSV()
        multi.inputImage = Temp!
        multi.inputOrangeShift = .init(x: -0.030447764322161664, y: 1.1289552450180054, z: 1)
        multi.inputGreenShift = .init(x: -0.086567163467407199,  y: 0.80985075235366821, z: 1)
        multi.inputYellowShift = .init(x: -0.078955218195915194, y: 0.97074621915817261, z: 1)
        multi.inputBlueShift = .init(x: -0.036268647760152817, y: 0.75283581018447876, z: 1)
        multi.inputAquaShift = .init(x: -0.034477628767490387, y: 0.67850750684738159, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1.0480597019195557, z: 1)
        
        let Ex = self.exposureAdjust(inputImage: multi.outputImage!, inputEV: 0.15)
        let Sharp = self.sharpenLuminance(inputImage: Ex!, inputSharpness: 0.12507465481758118)
        
        return F19(ciimage: Sharp!)
    }
    
    func RB0(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        let c7 = self.C2(ciimage: ciimage)
        
        let angle:Float = -15 * .pi / 180
        
        let Hue = CIFilter(name: "CIHueAdjust")
        Hue?.setDefaults()
        Hue?.setValue(c7, forKey: kCIInputImageKey)
        Hue?.setValue(NSNumber(value: angle), forKey: "inputAngle")
        
        return Hue?.outputImage
    }

    
    func RB1(ciimage:CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let c7 = self.C1(ciimage: ciimage)
        let angle:Float = 15 * .pi / 180
        
        let Hue = CIFilter(name: "CIHueAdjust")
        Hue?.setDefaults()
        Hue?.setValue(c7, forKey: kCIInputImageKey)
        Hue?.setValue(NSNumber(value: angle), forKey: "inputAngle")
        return Hue?.outputImage
    }
    
    func M0(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {
            return nil
        }
        
        let p = self.CIPhotoEffectMono(ciimage: ciimage)
        
        let r = CIVector.init(x: 1, y: 0, z: 0, w: 0.03)
        
        let colorMatrix = CIFilter(name: "CIColorMatrix")
        colorMatrix?.setDefaults()
        colorMatrix?.setValue(p!, forKey: kCIInputImageKey)
        colorMatrix?.setValue(r, forKey: "inputRVector")
       
        
        return self.G6(ciimage: colorMatrix?.outputImage)
    }
    
    func M1(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {
            return nil
        }
        
        let min = CIVector(x: 0.05, y: 0, z: 0, w: 0)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
//        colorClamp?.setValue(, forKey: "inputMaxComponents")
        
        let colorControl = self.colorControls(inputImage: colorClamp!.outputImage!, inputSaturation: 0.6)
        return self.G6(ciimage: colorControl)
    }
    
    func M2(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {
            return nil
        }
        
        let min = CIVector(x: 0.08, y: 0.04, z: 0.04, w: 0)
        let max = CIVector(x: 0.6, y: 0.6, z: 0.6, w: 1)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
        colorClamp?.setValue(max, forKey: "inputMaxComponents")
        
        let colorControl = self.colorControls(inputImage: colorClamp!.outputImage!, inputSaturation: 0.8)
        return self.G6(ciimage: colorControl)
    }
    
    func M3(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {
            return nil
        }
        
        let min = CIVector(x: 0.01, y: 0.04, z: 0.04, w: 0)
        let max = CIVector(x: 0.6, y: 0.6, z: 0.6, w: 1)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
        colorClamp?.setValue(max, forKey: "inputMaxComponents")
        
        let colorControl = self.colorControls(inputImage: colorClamp!.outputImage!, inputSaturation: 0.8)
        return self.G6(ciimage: colorControl)
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
    
    public var toCGImage: CGImage? {
        if let r = self.context?.createCGImage(self, from: self.extent) {
            self.clear()
            return r
        }
        return nil
    }
    
    public var RanderImage:UIImage? {
        if let r = self.context?.createCGImage(self, from: self.extent) {
            self.clear()
            return UIImage(cgImage: r)
        }
        return nil
    }
}

func F19 (ciimage:CIImage) -> CIImage {
    let value:[String:Any] = ["inputRedCoefficients":CIVector.init(x: -0.015, y: 1, z: -0.1, w: -0.1), "inputGreenCoefficients":CIVector.init(x: 0, y: 1.05, z: -0.1, w: 0), "inputBlueCoefficients":CIVector.init(x: 0, y: 1, z: 0.2, w: 0), "inputAlphaCoefficients":CIVector.init(x: 0, y: 1, z: 0, w: 0)]
    let ColorPolynomial = ciimage.applyingFilter("CIColorPolynomial", parameters: value)
    let ColorControl = ColorPolynomial.applyingFilter("CIColorControls", parameters: ["inputSaturation":1.2, "inputContrast":1.01, "inputBrightness":0])
    return ColorControl
}

func F2(ciimage:CIImage) -> CIImage {
    let Temp = ciimage.applyingFilter("CITemperatureAndTint", parameters: ["inputNeutral":CIVector.init(x: 7000, y: 0), "inputTargetNeutral": CIVector.init(x: 6500, y: 0)])
    let ColorControl = Temp.applyingFilter("CIColorControls", parameters: ["inputSaturation":1, "inputContrast":1.005, "inputBrightness": 0])
    
    //        let Vibrance = ColorControl.applyingFilter("CIVibrance", parameters: ["inputAmount":-0.2])
    
    let ColorPolynomialValue:[String:Any] = ["inputRedCoefficients":CIVector.init(x: 0, y:1, z: -0.05, w: 0.05),"inputGreenCoefficients":CIVector.init(x: 0, y: 1, z: 0, w: 0),"inputBlueCoefficients":CIVector.init(x: 0, y: 1, z: -0.1, w: 0),"inputAlphaCoefficients":CIVector.init(x: 0, y: 1.1, z: 0, w: 0)]
    let ColorPolynomial = ColorControl.applyingFilter("CIColorPolynomial", parameters: ColorPolynomialValue)
    
    let ColorMatrixValue:[String:Any] = ["inputRVector":CIVector.init(x: 1.05, y: -0.05, z: -0.05, w: -0.02), "inputGVector":CIVector.init(x: -0.1, y: 1, z: -0.05, w: 0), "inputBVector":CIVector.init(x: 0, y: 0, z: 1, w: 0), "inputAVector":CIVector.init(x: 0, y: 0, z: 0, w: 1)]
    let ColorMatrix = ColorPolynomial.applyingFilter("CIColorMatrix", parameters: ColorMatrixValue)
    //
    let ToneCurveValue:[String:Any] = ["inputPoint0":CIVector.init(x: -0.5, y: 0.1), "inputPoint1":CIVector.init(x: 0.26, y: 0.25), "inputPoint2":CIVector.init(x: 0.46, y: 0.49), "inputPoint3":CIVector.init(x: 0.75, y: 0.75), "inputPoint4":CIVector.init(x: 1, y: 1)]
    let ToneCurve = ColorMatrix.applyingFilter("CIToneCurve", parameters: ToneCurveValue)
    
    return ToneCurve
}

//
//func filter() {
//    guard let ciimage = ciimage else {return nil}
//
//    let c7 = self.C7(ciimage: ciimage)
//
//    let angle:Float = -15 * .pi / 180
//
//    let Hue = CIFilter(name: "CIHueAdjust")
//    Hue?.setDefaults()
//    Hue?.setValue(c7, forKey: kCIInputImageKey)
//    Hue?.setValue(NSNumber(value: angle), forKey: "inputAngle")
//
//    let colorTop = UIColor(red: 255.0/255.0, green: 178/255.0, blue: 134/255.0, alpha: 0.5).cgColor
//    let colorBottom = UIColor(red: 250/255.0, green: 97/255.0, blue: 97/255.0, alpha: 0.5).cgColor
//
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [colorTop, colorBottom]
//    gradientLayer.locations = [0.0, 1.0]
//    gradientLayer.startPoint = .init(x: 0.25, y: 0.25)
//    gradientLayer.endPoint = .init(x: 1, y: 1)
//    gradientLayer.frame.size = ciimage.extent.size
//
//    //start
//    UIGraphicsBeginImageContext(ciimage.extent.size)
//
//    gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    //end
//
//    let filter = CIFilter(name: "CIMultiplyCompositing")
//    filter?.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
//    filter?.setValue(Hue?.outputImage, forKey: kCIInputBackgroundImageKey)
//}
