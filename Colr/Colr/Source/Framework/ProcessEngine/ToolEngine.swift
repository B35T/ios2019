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
    
    func toolCreate(t:tool, ciimage:CIImage, Profile:ProcessEngineProfileModel, value:Float) -> CIImage? {
//        switch t {
//        case .exposure:
//            return self.exposureAdjust(inputImage: ciimage, inputEV: NSNumber(value: Float(Profile.exposure ?? 0)))
//        case .saturation, .brightness, .contrast:
//            let s = NSNumber(value: Float(Profile.saturation ?? 1))
//            let b = NSNumber(value: Float(Profile.brightness ?? 0))
//            let c = NSNumber(value: Float(Profile.contrast ?? 1))
//            return self.colorControls(inputImage: ciimage, inputSaturation: s, inputBrightness: b, inputContrast: c)
//        case .highlight, .shadow:
//            let h = NSNumber(value: Float(Profile.highlight ?? 0))
//            let s = NSNumber(value: Float(Profile.shadow ?? 0))
//            return self.highlightShadowAdjust(inputImage: ciimage, inputShadowAmount: s, inputHighlightAmount: h)
//        case .temperature, .tint:
//            let n = CIVector(x: Profile.temperature ?? 6500, y: 0)
//            let t = CIVector(x: Profile.tint ?? 6500, y: 0)
//            return self.temperatureAndTint(inputImage: ciimage, inputNeutral: n, inputTargetNeutral: t)
//        case .vibrance:
//            return self.vibrance(inputImage: ciimage, inputAmount: NSNumber(value: Profile.vibrance?.toFloat ?? 0))
//        case .gamma:
//            return self.gammaAdjust(inputImage: ciimage, inputPower: NSNumber(value: Profile.gamma?.toFloat ?? 1))
//        case .sharpan:
//            return self.sharpenLuminance(inputImage: ciimage, inputSharpness: NSNumber(value: Profile.sharpen?.toFloat ?? 1))
//        }
        
        var ci:CIImage = self.exposureAdjust(inputImage: ciimage, inputEV: NSNumber(value: Float(Profile.exposure ?? 0)))!
        let s = NSNumber(value: Float(Profile.saturation ?? 1))
        let b = NSNumber(value: Float(Profile.brightness ?? 0))
        let c = NSNumber(value: Float(Profile.contrast ?? 1))
        ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        let h = NSNumber(value: Float(Profile.highlight ?? 1))
        let sh = NSNumber(value: Float(Profile.shadow ?? 0))
        ci = self.highlightShadowAdjust(inputImage: ci, inputShadowAmount: sh, inputHighlightAmount: h)!
        let n = CIVector(x: Profile.temperature ?? 6500, y: 0)
        let t = CIVector(x: Profile.tint ?? 6500, y: 0)
        ci = self.temperatureAndTint(inputImage: ci, inputNeutral: n, inputTargetNeutral: t)!
        ci = self.vibrance(inputImage: ci, inputAmount: NSNumber(value: Profile.vibrance?.toFloat ?? 0))!
        ci = self.gammaAdjust(inputImage: ci, inputPower: NSNumber(value: Profile.gamma?.toFloat ?? 1))!
        ci = self.sharpenLuminance(inputImage: ci, inputSharpness: NSNumber(value: Profile.sharpen?.toFloat ?? 0))!
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
