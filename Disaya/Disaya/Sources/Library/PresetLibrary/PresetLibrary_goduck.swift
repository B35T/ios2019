//
//  PresetLibrary_goduck.swift
//  Disaya
//
//  Created by chaloemphong on 7/12/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension PresetLibrary {
    func Goduck_G5(ciimage: CIImage?) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        let min = CIVector(x: 0.01, y: 0.005, z: 0.005, w: 0)
        let max = CIVector(x: 1, y: 1, z: 1, w: 1)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
        colorClamp?.setValue(max, forKey: "inputMaxComponents")
        
        let Con = self.colorControls(inputImage: colorClamp!.outputImage!, inputSaturation: 1, inputContrast: 1.015)
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
        let gr = self.Grain(value: 0.3, buttom: fade!)
        return F19(ciimage: gr!)
    }
    
    func Goduck_G6(ciimage: CIImage?) -> CIImage? {
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
        let gr = self.Grain(value: 0.3, buttom: Sharp!)
        return F19(ciimage: gr!)
    }
    
    func Goduck_C9(ciimage: CIImage?) -> CIImage? {
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
        let gr = self.Grain(value: 0.3, buttom: Sharp!)
        return F19(ciimage: gr!)
    }
    
    func Goduck_CINE0(ciimage: CIImage?) -> CIImage? {
        
        let min = CIVector(x: 0.005, y: 0.01, z: 0.005, w: 0)
        let max = CIVector(x: 1, y: 1, z: 1, w: 1)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
        colorClamp?.setValue(max, forKey: "inputMaxComponents")
        
        
        let multi = MultiBandHSV()
        multi.inputImage = colorClamp?.outputImage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: -0.03,  y: 1.15, z: 1)
        multi.inputYellowShift = .init(x: -0.03, y: 1.15, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let temp = self.temperatureAndTint(inputImage: multi.outputImage!, inputNeutral: .init(x: 5500, y: 0), inputTargetNeutral: .init(x: 7000, y: 0))
        let sharp = self.sharpenLuminance(inputImage: temp!, inputSharpness: 0.3)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        return gr
    }
    
    func Goduck_CINE5(ciimage: CIImage?) -> CIImage? {
        let min = CIVector(x: 0.005, y: 0.005, z: 0.01, w: 0)
        let max = CIVector(x: 1, y: 1, z: 1, w: 1)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp?.setDefaults()
        colorClamp?.setValue(ciimage, forKey: "inputImage")
        colorClamp?.setValue(min, forKey: "inputMinComponents")
        colorClamp?.setValue(max, forKey: "inputMaxComponents")
        
        let multi = MultiBandHSV()
        multi.inputImage = colorClamp?.outputImage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: 0.05,  y: 0.7, z: 1)
        multi.inputYellowShift = .init(x: 0.08, y: 0.7, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 0.8, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let sharp = self.sharpenLuminance(inputImage: multi.outputImage!, inputSharpness: 0.2)
        let c = F19(ciimage: sharp!)
        let gr = self.Grain(value: 0.3, buttom: c)
        return gr
    }
}
