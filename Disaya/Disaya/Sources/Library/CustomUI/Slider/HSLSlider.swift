//
//  HSLSlider.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class HSLSlider: Slider {
    
    func add() {
        self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        self.minimumTrackTintColor = .white
        self.maximumTrackTintColor = .white
    }
}
