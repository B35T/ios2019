//
//  Other.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension CGFloat {
    func persent(_ p: CGFloat) -> CGFloat {
        return (self / 100) * p
    }
}


open class appDefualt {
    
    let device = UIScreen.main.bounds
    
    class var shared: appDefualt {
        struct Static {
            static let instence: appDefualt = appDefualt()
        }
        return Static.instence
    }
    
    var position: CGFloat {
        if device.height > 800 {
            return 50
        } else {
            return 20
        }
    }
    
    var positionC: CGFloat {
        return 0
    }
    
    var positionB: CGFloat {
        if device.height > 800 {
            return 50
        } else {
            return 70
        }
    }
}
