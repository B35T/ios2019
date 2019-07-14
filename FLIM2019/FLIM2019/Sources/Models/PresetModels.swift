//
//  PresetModels.swift
//  FLIM2019
//
//  Created by chaloemphong on 12/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class PresetModels {
    
    enum preset:String {
        case item1 = "item1"
        case item2 = "item2"
        case item3 = "item3"
        case item4 = "item4"
        case item5 = "item5"
        case item6 = "item6"
        case none = "none"
    }
    
    public let items = ["item1","item2","item3","item4", "item5", "item6"]
 
    func creator(ciimage:CIImage? ,item:preset, presets:PresetLibrary = PresetLibrary()) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        switch item {
        case .none:return nil
        case .item1:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 4
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 8
            let grain = presets.Grain(value: 0.5, buttom: trans.outputImage!)
            return presets.M2(ciimage: grain)
        case .item2:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2.5
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 6
            let grain = presets.Grain(value: 0.5, buttom: trans.outputImage!)
            return presets.RB0(ciimage: grain)
        case .item3:
            let grain = presets.Grain(value: 0.5, buttom: ciimage)
            return presets.C1(ciimage: grain)
        case .item4:
            let grain = presets.Grain(value: 0.5, buttom: ciimage)
            return presets.C5(ciimage: grain)
        case .item5:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2.5
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 6
            let grain = presets.Grain(value: 0.3, buttom: trans.outputImage!)
            return presets.C4(ciimage: grain)
        case .item6:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2.5
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 6
            let grain = presets.Grain(value: 0.5, buttom: trans.outputImage!)
            return presets.M0(ciimage: grain)
        }
    }
}
