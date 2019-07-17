//
//  color.swift
//  FLIM2019
//
//  Created by chaloemphong on 4/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

let bg = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
let film = UIColor(red: 96/255, green: 42/255, blue: 42/255, alpha: 1)
let blue = UIColor(red:0.00, green:0.46, blue:1.00, alpha:1.0)


extension UIButton {
    func blur() {
        let blur = UIBlurEffect.init(style: .regular)
        let blurView = UIVisualEffectView()
        blurView.frame = .init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blurView.effect = blur
        self.addSubview(blurView)
    }
}
