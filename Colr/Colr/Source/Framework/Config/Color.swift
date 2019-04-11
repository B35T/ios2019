//
//  HSLConfig.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
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
