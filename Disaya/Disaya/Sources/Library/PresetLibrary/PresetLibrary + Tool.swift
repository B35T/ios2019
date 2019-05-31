//
//  PresetLibrary + Tool.swift
//  Disaya
//
//  Created by chaloemphong on 21/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.

import UIKit
import Foundation
import CoreImage

public enum tool:Int {
    case exposure = 0
    case saturation
    case contrast
    case highlight
    case shadow
    case temperature
    case vibrance
    case gamma
    case sharpan
    case bloom
    case grian
}

extension PresetLibrary {
    
    func toolmin(t:tool) -> (min:Float, max:Float, value:Float) {
        switch t {
        case .exposure:
            return (0, 1, Float(DisayaProfile.shared.exposure ?? 0))
        case .saturation:
            return (0, 2, Float(DisayaProfile.shared.saturation ?? 1))
        case .contrast:
            return (0.5, 1.5, Float(DisayaProfile.shared.contrast ?? 1))
        case .highlight:
            return (0, 1, Float(DisayaProfile.shared.highlight ?? 1))
        case .shadow:
            return (-1, 1,Float(DisayaProfile.shared.shadow ?? 0))
        case .temperature:
            return (3500, 9500, Float(DisayaProfile.shared.temperature ?? 6500))
        case .vibrance:
            return (-1, 1, Float(DisayaProfile.shared.vibrance ?? 0))
        case .gamma:
            return (0, 2, Float(DisayaProfile.shared.gamma ?? 1))
        case .sharpan:
            return (-2, 2, Float(DisayaProfile.shared.sharpen ?? 0))
        case .bloom:
            return (0, 10, Float(DisayaProfile.shared.bloom ?? 0))
        case .grian:
            return (0, 1, Float(DisayaProfile.shared.grain ?? 0))
        }
    }
    
    func toolCreate(ciimage:CIImage, Profile:DisayaProfile?, scale:CGFloat = 1) -> CIImage? {
        var ci:CIImage = ciimage
        
        if let HSL = Profile?.HSL {
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
        
        if let exposure = Profile?.exposure {
            ci = self.exposureAdjust(inputImage: ciimage, inputEV: NSNumber(value: exposure.toFloat))!
        }
        
        var s = NSNumber(value: 1)
        var b = NSNumber(value: 0)
        var c = NSNumber(value: 1)
        
        if let saturation = Profile?.saturation {
            s = NSNumber(value: saturation.toFloat)
            ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        }
        
        if let brightness = Profile?.brightness {
            b = NSNumber(value: brightness.toFloat)
            ci = self.colorControls(inputImage: ci, inputSaturation: s, inputBrightness: b, inputContrast: c)!
        }
        
        if let contrast = Profile?.contrast {
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
    
        if let temperature = Profile?.temperature {
            ci = self.temperatureAndTint(inputImage: ci, inputNeutral: CIVector(x: temperature, y: 0), inputTargetNeutral: CIVector(x: 6500, y: 0))!
        }
        
        if let vibrance = Profile?.vibrance {
            ci = self.vibrance(inputImage: ci, inputAmount: NSNumber(value: vibrance.toFloat))!
        }
        
        if let gamma = Profile?.gamma {
            ci = self.gammaAdjust(inputImage: ci, inputPower: NSNumber(value: gamma.toFloat))!
        }
        
        if let filter = Profile?.filter {
            ci = self.filter(indexPath: filter, ciimage: ci) ?? ci
        }
        
        if let sharpen = Profile?.sharpen {
            let c = sharpen
            ci = self.sharpenLuminance(inputImage: ci, inputSharpness: NSNumber(value: Float(c)))!
        }
        
        if let bloom = Profile?.bloom {
            ci = self.bloom(inputImage: ci, inputRadius: NSNumber(value: bloom.toFloat))!
        }
        
        if let grain = Profile?.grain {
            ci = self.Grain(value: grain, buttom: ci)!
//
//            let filter = CIFilter(name: "CIMultiplyCompositing")
//            let colorFilter = CIFilter(name: "CIConstantColorGenerator")
//            let ciColor = CIColor(color: yellow.withAlphaComponent(0.3))
//            colorFilter?.setValue(ciColor, forKey: kCIInputColorKey)
//            let colorImage = colorFilter?.outputImage
//            filter?.setValue(colorImage, forKey: kCIInputImageKey)
//            filter?.setValue(ci, forKey: kCIInputBackgroundImageKey)
//            ci = filter!.outputImage!
            
        }
        
        if let a = Profile?.chromatic_angle, let r = Profile?.chromatic_radius {
            let ca = ChromaticAberration()
            ca.inputImage = ci
            ca.inputAngle = a
            ca.inputRadius = r * scale
            
            ci = ca.outputImage
        }
        
        if let b = Profile?.transverse_blur, let off = Profile?.transverse_falloff {
            let ta = TransverseChromaticAberration()
            ta.inputImage = ci
            ta.inputFalloff = off
            ta.inputBlur = b * scale
            
            ci = ta.outputImage!
        }
        
        return ci
    }
    
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
    
    func sharpenLuminance(inputImage: CIImage, inputSharpness: NSNumber = 2) -> CIImage? {
        guard let filter = CIFilter(name: "CISharpenLuminance") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(inputSharpness, forKey: "inputSharpness")
        return filter.outputImage
    }
}

