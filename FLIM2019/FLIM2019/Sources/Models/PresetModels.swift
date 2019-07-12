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
        case none = "none"
    }
    
 
    func creator(ciimage:CIImage? ,item:preset, presets:PresetLibrary = PresetLibrary()) -> CIImage? {
        guard let ciimage = ciimage else {return nil}
        
        switch item {
        case .none:return nil
        case .item1: return presets.M2(ciimage: ciimage)
        case .item2:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 4
            return presets.RB0(ciimage: trans.outputImage)
        case .item3: return presets.C1(ciimage: ciimage)
        case .item4: return presets.C5(ciimage: ciimage)
        }
    }
}
