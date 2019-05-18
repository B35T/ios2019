//
//  DisayaProfile.swift
//  Disaya
//
//  Created by chaloemphong on 18/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


class Color {
    public var red:UIColor {return UIColor(red: 0.901961, green: 0.270588, blue: 0.270588, alpha: 1)}
    public var orange:UIColor {return UIColor(red: 0.901961, green: 0.584314, blue: 0.270588, alpha: 1)}
    public var yellow:UIColor {return UIColor(red: 0.901961, green: 0.901961, blue: 0.270588, alpha: 1)}
    public var green:UIColor {return UIColor(red: 0.270588, green: 0.901961, blue: 0.270588, alpha: 1)}
    public var aque:UIColor {return UIColor(red: 0.270588, green: 0.901961, blue: 0.901961, alpha: 1)}
    public var blue:UIColor {return UIColor(red: 0.270588, green: 0.270588, blue: 0.901961, alpha: 1)}
    public var purple:UIColor {return UIColor(red: 0.584314, green: 0.270588, blue: 0.901961, alpha: 1)}
    public var magenta:UIColor {return UIColor(red: 0.901961, green: 0.270588, blue: 0.901961, alpha: 1)}
    
    public var HSLColors:[UIColor] {
        return [self.red, self.orange, self.yellow, self.green, self.aque, self.blue, self.purple, self.magenta]
    }
    
    public enum HSLColorSet: Int {
        case red = 0
        case orange
        case yellow
        case green
        case aque
        case blue
        case purple
        case magenta
        
        var count: Int {
            return 8
        }
    }
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

open class DisayaProfile {
    
    var filter: Int?
    var HSL: HSLModel?
    var chromatic: ChromaticModel?
    var transverseChromatic:TransverseChromaticModel?
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
    
    var red: HSLVector?
    var green:HSLVector?
    var blue:HSLVector?
    var orange:HSLVector?
    var yellow:HSLVector?
    var aqua:HSLVector?
    var purple:HSLVector?
    var magenta:HSLVector?
    
    static let shared: DisayaProfile = DisayaProfile()
    
    var json: [String:Any?] {
        return ["HSL":HSL?.json,"Chromatic":chromatic?.json, "TransverseChromatic":transverseChromatic?.json, "white": white, "saturation":saturation, "fade":fade, "exposure": exposure, "contrast":contrast, "hue":hue, "sharpen":sharpen, "highlight": highlight, "shadow":shadow, "temperature":temperature, "vibrance":vibrance, "grain":grain, "gamma":gamma, "bloom":bloom]
    }
    
}

extension CGFloat {
    var toFloat:Float {
        return Float(self)
    }
}
