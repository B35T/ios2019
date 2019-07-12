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
        case none = "none"
    }
    
    public let items = ["item1","item2","item3","item4", "item5"]
 
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
            return presets.M2(ciimage: trans.outputImage)
        case .item2:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2.5
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 6
            return presets.RB0(ciimage: trans.outputImage)
        case .item3: return presets.C1(ciimage: ciimage)
        case .item4: return presets.C5(ciimage: ciimage)
        case .item5:
            let chrom = ChromaticAberration()
            chrom.inputImage = ciimage
            chrom.inputRadius = 2.5
            let trans = TransverseChromaticAberration()
            trans.inputImage = chrom.outputImage
            trans.inputFalloff = 0.6
            trans.inputBlur = 6
            return presets.C4(ciimage: trans.outputImage)
        }
    }
}
