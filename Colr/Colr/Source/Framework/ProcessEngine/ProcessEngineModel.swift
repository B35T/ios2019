//
//  ProcessEngineModel.swift
//  Colr
//
//  Created by chaloemphong on 12/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


public enum Filter:Int {
    case P0 = 0
    case P1
    case P2
    case P3
    case P4
    case P5
    case P6
    case P7
    case P8
    case P9
    case P10
    case P11
    case P12
    
    var count: Int {
        return 13
        
    }
}

public enum LightTool {
    case Exposure
    case Contrast
    case White
    case Hue
    case Grain
    case Fade
    case Highlight
    case Shadow
    case Saturation
    case Vibrance
    case Temperature
    case Gamma
    case Tint
    case Sharpan
    case SplitTone
}

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
    
    mutating func update(color:Color.HSLColorSet, value: HSLVector?) {
        switch color {
        case .red: self.red = value
        case .green: self.green = value
        case .blue: self.blue = value
        case .orange: self.orange = value
        case .yellow: self.yellow = value
        case .aque: self.aqua = value
        case .purple: self.purple = value
        case .magenta: self.magenta = value
        }
    }
    
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
    var filter: Int?
    
    var HSL: HSLModel?
    var Chromatic:ChromaticModel?
    var TransverseChromatic:TransverseChromaticModel?
    
    var white:CGFloat?
    var brightness:CGFloat?
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
    var tint:CGFloat?
    var split:CGFloat?
    var bloom:CGFloat?
    
    var json: [String:Any?] {
        return ["HSL":HSL?.json,"Chromatic":Chromatic?.json, "TransverseChromatic":TransverseChromatic?.json, "white": white, "saturation":saturation, "fade":fade, "exposure": exposure, "contrast":contrast, "hue":hue, "sharpen":sharpen, "highlight": highlight, "shadow":shadow, "temperature":temperature, "vibrance":vibrance, "grain":grain, "gamma":gamma, "bloom":bloom]
    }
    
    func get(name:String) -> CGFloat? {
        switch name {
        case "Brightness":return self.brightness
        case "Exposure":return self.exposure
        case "Contrast":return self.contrast
        case "White":return self.white
        case "Hue":return self.hue
        case "Grain":return self.grain
        case "Fade":return self.fade
        case "Highlight":return self.highlight
        case "Shadow":return self.shadow
        case "Saturation":return self.saturation
        case "Vibrance":return self.vibrance
        case "Temperature":return self.temperature
        case "Gamma":return self.gamma
        case "Tint":return self.tint
        case "Sharpan":return self.sharpen
        case "Split Tone":return self.split
        case "Bloom": return self.bloom
        default:
            return 0.0
        }
    }
    
    mutating func update(name:String, value:CGFloat){
        switch name {
        case "Brightness":self.brightness = value
        case "Exposure":self.exposure = value
        case "Contrast":self.contrast = value
        case "White":self.white = value
        case "Hue":self.hue = value
        case "Grain":self.grain = value
        case "Fade":self.fade = value
        case "Highlight":self.highlight = value
        case "Shadow":self.shadow = value
        case "Saturation":self.saturation = value
        case "Vibrance":self.vibrance = value
        case "Temperature":self.temperature = value
        case "Gamma":self.gamma = value
        case "Tint":self.tint = value
        case "Sharpan":self.sharpen = value
        case "Split Tone":self.split = value
        case "Bloom": self.bloom = value
        default:
            break
        }
    }
}

extension CGFloat {
    var toFloat:Float {
        return Float(self)
    }
}
