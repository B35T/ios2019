//
//  HSLEngine.swift
//  Colr
//
//  Created by chaloemphong on 12/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class HSLEngine {
    
    var HSV:MultiBandHSV {
        return MultiBandHSV()
    }
    
    var old = HSLModel()
    
    var red: HSLVector?
    var green:HSLVector?
    var blue:HSLVector?
    var orange:HSLVector?
    var yellow:HSLVector?
    var aqua:HSLVector?
    var purple:HSLVector?
    var magenta:HSLVector?
    
    public class var shared: HSLEngine {
        struct Static {
            static let instence: HSLEngine = HSLEngine()
        }
        return Static.instence
    }
}
