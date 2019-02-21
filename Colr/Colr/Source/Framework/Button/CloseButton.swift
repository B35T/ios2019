//
//  CloseButton.swift
//  Colr
//
//  Created by chaloemphong on 21/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class CloseButton: CustomButton {

    open override func add(view: UIView,_ p: CGPoint = .zero, _ s: CGSize = CGSize(width: 70, height: 40)) {
        self.frame = .init(origin: p, size: s)
        self.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        view.addSubview(self)
    }

    
}
