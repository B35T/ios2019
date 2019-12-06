//
//  PresetLibrary + Cinematic.swift
//  Disaya
//
//  Created by chaloemphong on 4/10/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
import UIKit

extension PresetLibrary {
    func CINE0(ciimage: CIImage?) -> CIImage? {
        
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
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
    
    func CINE1(ciimage: CIImage?) -> CIImage? {
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: -0.03,  y: 1.15, z: 1)
        multi.inputYellowShift = .init(x: -0.03, y: 1.15, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let temp = self.temperatureAndTint(inputImage: multi.outputImage!, inputNeutral: .init(x: 8000, y: 0))
        let sharp = self.sharpenLuminance(inputImage: temp!, inputSharpness: 0.3)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        return gr
    }
    
    func CINE2(ciimage: CIImage?) -> CIImage? {
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: 0.03,  y: 1.15, z: 1)
        multi.inputYellowShift = .init(x: 0.03, y: 1.15, z: 1)
        multi.inputBlueShift = .init(x: 0.02, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let temp = self.temperatureAndTint(inputImage: multi.outputImage!, inputNeutral: .init(x: 5500, y: 0))
        let sharp = self.sharpenLuminance(inputImage: temp!, inputSharpness: 0.3)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        return gr
    }
    
    func CINE3(ciimage: CIImage?) -> CIImage? {
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: 0.05,  y: 1.25, z: 1)
        multi.inputYellowShift = .init(x: 0.08, y: 0.9, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let temp = self.temperatureAndTint(inputImage: multi.outputImage!, inputNeutral: .init(x: 8000, y: 0))
        let sharp = self.sharpenLuminance(inputImage: temp!, inputSharpness: 0.2)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        let c = F19(ciimage: gr!)
        return c
    }
    
    func CINE4(ciimage: CIImage?) -> CIImage? {
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: 0.05,  y: 1.25, z: 1)
        multi.inputYellowShift = .init(x: 0.08, y: 0.9, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 1.2, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let temp = self.temperatureAndTint(inputImage: multi.outputImage!, inputNeutral: .init(x: 8000, y: 0))
        let sharp = self.sharpenLuminance(inputImage: temp!, inputSharpness: 0.2)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        let c = self.C2(ciimage: gr!)
        return c
    }
    
    func CINE5(ciimage: CIImage?) -> CIImage? {
        let multi = MultiBandHSV()
        multi.inputImage = ciimage
        multi.inputOrangeShift = .init(x: 0.03, y: 1.05, z: 1)
        multi.inputGreenShift = .init(x: 0.05,  y: 0.7, z: 1)
        multi.inputYellowShift = .init(x: 0.08, y: 0.7, z: 1)
        multi.inputBlueShift = .init(x: -0.07, y: 0.8, z: 1)
        multi.inputRedShift = .init(x: 0, y: 1, z: 1)
        
        let sharp = self.sharpenLuminance(inputImage: multi.outputImage!, inputSharpness: 0.2)
        let gr = self.Grain(value: 0.3, buttom: sharp!)
        let c = F19(ciimage: gr!)
        return c
    }
}
