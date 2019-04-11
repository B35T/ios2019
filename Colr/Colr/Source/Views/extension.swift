//
//  extension.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

extension UIImageView {
    func scale(view: UIView ,persen: CGFloat = 100, duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            let m = view.frame.height.persen(p: persen)
            self.frame.size.height = m
        }
    }
}
