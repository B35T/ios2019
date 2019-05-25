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
    
    mutating func defualt() {
        self.red = nil
        self.green = nil
        self.blue = nil
        self.orange = nil
        self.yellow = nil
        self.aqua = nil
        self.purple = nil
        self.magenta = nil
        
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
    
    var HSL: HSLModel?
    var chromatic: ChromaticModel?
    var transverseChromatic:TransverseChromaticModel?
    
    var filter: IndexPath?
    
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

    var chromatic_angle: CGFloat?
    var chromatic_radius: CGFloat?
    var transverse_falloff:CGFloat?
    var transverse_blur:CGFloat?
    
    var red: HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var green:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var blue:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var orange:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var yellow:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var aqua:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var purple:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    var magenta:HSLVector? {
        didSet {
            self.update_HSL()
        }
    }
    
    static let shared: DisayaProfile = DisayaProfile()
    
    var json: [String:Any?] {
        return ["HSL":HSL?.json,"Chromatic":chromatic?.json, "TransverseChromatic":transverseChromatic?.json, "white": white, "saturation":saturation, "fade":fade, "exposure": exposure, "contrast":contrast, "hue":hue, "sharpen":sharpen, "highlight": highlight, "shadow":shadow, "temperature":temperature, "vibrance":vibrance, "grain":grain, "gamma":gamma, "bloom":bloom]
    }
 
    func update_HSL() {
        let r = self.red ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let g = self.green ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let b = self.blue ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let o = self.orange ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let y = self.yellow ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let a = self.aqua ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let p = self.purple ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        let m = self.magenta ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        DisayaProfile.shared.HSL = HSLModel(red: r, green:g, blue: b, orange: o, yellow: y, aqua: a, purple: p, magenta: m)
    }
    
    func update_chromatic() {
        let a = self.chromatic_angle ?? 0
        let r = self.chromatic_radius ?? 0
        self.chromatic = ChromaticModel(angle: a, radius: r)
    }
    
    func update_transverse() {
        let fall = self.transverse_falloff ?? 0
        let blur = self.transverse_blur ?? 0
        self.transverseChromatic = TransverseChromaticModel(falloff: fall, blur: blur)
    }
    
    func defualt() {
        self.filter = nil
        
        self.white = nil
        self.brightness = nil
        self.saturation = nil
        self.fade = nil
        self.exposure = nil
        self.contrast = nil
        self.hue = nil
        self.sharpen = nil
        self.highlight = nil
        self.shadow = nil
        self.temperature = nil
        self.vibrance = nil
        self.grain = nil
        self.gamma = nil
        self.tint = nil
        self.split = nil
        self.bloom = nil
        
        //HSL
        self.red = nil
        self.green = nil
        self.blue = nil
        self.orange = nil
        self.yellow = nil
        self.aqua = nil
        self.purple = nil
        self.magenta = nil
        
        self.chromatic_angle = nil
        self.chromatic_radius = nil
        self.transverse_falloff = nil
        self.transverse_blur = nil
        
        self.HSL = nil
        self.chromatic = nil
        self.transverseChromatic = nil
    }
    
    func valueTools(t:tool) -> CGFloat? {
        switch t {
        case .exposure:
            return DisayaProfile.shared.exposure
        case .saturation:
            return DisayaProfile.shared.saturation
        case .contrast:
            return DisayaProfile.shared.contrast
        case .highlight:
            return DisayaProfile.shared.highlight
        case .shadow:
            return DisayaProfile.shared.shadow
        case .temperature:
            return DisayaProfile.shared.temperature
        case .vibrance:
            return DisayaProfile.shared.vibrance
        case .gamma:
            return DisayaProfile.shared.gamma
        case .sharpan:
            return DisayaProfile.shared.shadow
        case .bloom:
            return DisayaProfile.shared.bloom
        case .grian:
            return DisayaProfile.shared.grain
        }
    }
    
    func updateTools(t:tool, value:CGFloat){
        switch t {
        case .exposure:
            DisayaProfile.shared.exposure = value
        case .saturation:
            DisayaProfile.shared.saturation = value
        case .contrast:
            DisayaProfile.shared.contrast = value
        case .highlight:
            DisayaProfile.shared.highlight = value
        case .shadow:
            DisayaProfile.shared.shadow = value
        case .temperature:
            DisayaProfile.shared.temperature = value
        case .vibrance:
            DisayaProfile.shared.vibrance = value
        case .gamma:
            DisayaProfile.shared.gamma = value
        case .sharpan:
            DisayaProfile.shared.shadow = value
        case .bloom:
            DisayaProfile.shared.bloom = value
        case .grian:
            DisayaProfile.shared.grain = value
        }
    }
}

extension CGFloat {
    var toFloat:Float {
        return Float(self)
    }
}
