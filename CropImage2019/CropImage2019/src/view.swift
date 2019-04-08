//
//  view.swift
//  CropImage2019
//
//  Created by chaloemphong on 29/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


open class view: UIView {
    var identifier: String? = nil
    var rect:CGRect = .zero {
        didSet {
            self.frame = self.rect
        }
    }
    public func config() {}
    
    public func updateContent() {}
    
    public func add_icon() {}
}
