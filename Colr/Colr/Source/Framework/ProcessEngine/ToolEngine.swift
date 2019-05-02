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

public enum tool:Int {
    case exposure = 0
    case saturation
    case brightness
    case contrast
    case highlight
    case shadow
    case temperature
    case tint
    case vibrance
    case gamma
    case sharpan
}

extension ProcessEngine {
    func toolmin(t:tool) -> (min:Float, max:Float, value:Float) {
        switch t {
        case .exposure:
            return (0, 1, 0)
        case .saturation:
            return (0, 2, 1)
        case .brightness:
            return (-0.5, 0.5, 0)
        case .contrast:
            return (0, 2, 1)
        case .highlight:
            return (0, 1, 1)
        case .shadow:
            return (-1, 1,0)
        case .temperature:
            return (3500, 9500, 6500)
        case .tint:
            return (3500, 9500, 6500)
        case .vibrance:
            return (-1, 1, 0)
        case .gamma:
            return (0, 2, 1)
        case .sharpan:
            return (-2, 2, 0)
        }
    }
    
    func toolCreate(ciimage:CIImage, Profile:ProcessEngineProfileModel?) -> CIImage? {
        var ci:CIImage = ciimage
        if let exposure = Profile?.exposure {
            print("exposure")
            ci = self.exposureAdjust(inputImage: ciimage, inputEV: NSNumber(value: exposure.toFloat))!
        }
        
        var s = NSNumber(value: 1)
        var b = NSNumber(value: 0)
        var c = NSNumber(value: 1)
        
        if let saturation = Profile?.saturation {
            print("saturation")
            s = NSNumber(value: saturation.toFloat)
            ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        }
        
        if let brightness = Profile?.brightness {
            print("brightness")
            b = NSNumber(value: brightness.toFloat)
            ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        }
        
        if let contrast = Profile?.contrast {
            print("constast")
            c = NSNumber(value: contrast.toFloat)
            ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        }
        
        var h = NSNumber(value: 1)
        var sh = NSNumber(value: 0)
        
        if let highlight = Profile?.highlight {
            h = NSNumber(value: highlight.toFloat)
            ci = self.highlightShadowAdjust(inputImage: ci, inputShadowAmount: sh, inputHighlightAmount: h)!
        }
        
        if let shadow = Profile?.shadow {
            sh = NSNumber(value: shadow.toFloat)
            ci = self.highlightShadowAdjust(inputImage: ci, inputShadowAmount: sh, inputHighlightAmount: h)!
        }
        
        var n = CIVector(x: 6500, y: 0)
        var t = CIVector(x: 6500, y: 0)
        if let temperature = Profile?.temperature {
            n = CIVector(x: temperature, y: 0)
            ci = self.temperatureAndTint(inputImage: ci, inputNeutral: n, inputTargetNeutral: t)!
        }
        
        if let tint = Profile?.tint {
            t = CIVector(x: tint, y: 0)
            ci = self.temperatureAndTint(inputImage: ci, inputNeutral: n, inputTargetNeutral: t)!
        }
        
        if let vibrance = Profile?.vibrance {
            ci = self.vibrance(inputImage: ci, inputAmount: NSNumber(value: vibrance.toFloat))!
        }
        
        if let gamma = Profile?.gamma {
            ci = self.gammaAdjust(inputImage: ci, inputPower: NSNumber(value: gamma.toFloat))!
        }
        
        if let sharpen = Profile?.sharpen {
            ci = self.sharpenLuminance(inputImage: ci, inputSharpness: NSNumber(value: sharpen.toFloat))!
        }
        
        if let HSL = Profile?.HSL {
            print("HSL")
            let m = MultiBandHSV()
            m.inputImage = ci
 
            m.inputRedShift = HSL.red?.vector ?? CIVector(x: 0, y: 1, z: 1)
            m.inputOrangeShift = HSL.orange?.vector ?? CIVector(x: 0, y: 1, z: 1)
            m.inputYellowShift = HSL.yellow?.vector ?? CIVector(x: 0, y: 1, z: 1)
            m.inputGreenShift = HSL.green?.vector ??  CIVector(x: 0, y: 1, z: 1)
            m.inputAquaShift = HSL.aqua?.vector ??  CIVector(x: 0, y: 1, z: 1)
            m.inputBlueShift = HSL.blue?.vector ??  CIVector(x: 0, y: 1, z: 1)
            m.inputPurpleShift = HSL.purple?.vector ??  CIVector(x: 0, y: 1, z: 1)
            m.inputMagentaShift = HSL.magenta?.vector ??  CIVector(x: 0, y: 1, z: 1)
            
            ci = m.outputImage!
        }
        
        if let filter = Profile?.filter {
            ci = self.filter(index: filter, ciimage: ci) ?? ci
        }
        
        return ci
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
