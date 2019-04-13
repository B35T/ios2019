//
//  ProcessEngineModel.swift
//  Colr
//
//  Created by chaloemphong on 12/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public struct HSLVector {
    var hue: CGFloat
    var saturation: CGFloat
    var lightness: CGFloat
    
    var vector: CIVector {
        return .init(x: hue, y: saturation, z: lightness)
    }
    
    var json: [String:Any?] {
        return ["hue": hue, "saturation": saturation, "lightness": lightness]
    }
}

public struct HSLModel {    
    var red: HSLVector?
    var green:HSLVector?
    var blue:HSLVector?
    var orange:HSLVector?
    var yellow:HSLVector?
    var aqua:HSLVector?
    var purple:HSLVector?
    var magenta:HSLVector?
    
    var json: [String:Any?] {
        return ["red":red?.json, "green":green?.json, "blue": blue?.json, "orange": orange?.json, "yellow": yellow?.json, "aque":aqua?.json, "purple": purple?.json, "magenta": magenta?.json]
    }
}

public struct TransverseChromaticModel {
    var falloff:CGFloat
    var blur:CGFloat
    
    var json:[String:Any] {
        return ["falloff":falloff, "blur":blur]
    }
}

struct ChromaticModel {
    var angle:CGFloat
    var radius:CGFloat
    
    var json:[String:Any] {
        return ["angle":angle, "radius":radius]
    }
}

public struct ProcessEngineProfileModel {
    var HSL: HSLModel?
    var Chromatic:ChromaticModel?
    var TransverseChromatic:TransverseChromaticModel?
    
    var white:CGFloat?
    var saturation:CGFloat?
    var fade:CGFloat?
    var exposure:CGFloat?
    var contrast:CGFloat?
    var hue:CGFloat?
    var sharpen:CGFloat?
    var highlight:CGFloat?
    var shadow:CGFloat?
    var temperature:CGFloat?
    var vibrance:CGFloat?
    var grain:CGFloat?
    var gamma:CGFloat?
    
    var json: [String:Any?] {
        return ["HSL":HSL?.json,"Chromatic":Chromatic?.json, "TransverseChromatic":TransverseChromatic?.json, "white": white, "saturation":saturation, "fade":fade, "exposure": exposure, "contrast":contrast, "hue":hue, "sharpen":sharpen, "highlight": highlight, "shadow":shadow, "temperature":temperature, "vibrance":vibrance, "grain":grain, "gamma":gamma]
    }
}
