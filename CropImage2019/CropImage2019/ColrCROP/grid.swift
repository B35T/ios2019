//
//  grid.swift
//  CropImage2019
//
//  Created by chaloemphong on 29/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class grid: view {
    var horizontalTop: UIView!
    var horizontalBottom: UIView!
    var verticalLeft: UIView!
    var verticalRight: UIView!
    
    public var color = UIColor.white
    public var cornerRadius: CGFloat = 0.5
    public var freamRadius: CGFloat = 0.5
    
    
    public override func config() {
        super.config()
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = freamRadius
        
        self.horizontalTop = UIView()
        self.horizontalBottom = UIView()
        self.verticalLeft = UIView()
        self.verticalRight = UIView()

        self.horizontalTop.backgroundColor = color
        self.horizontalBottom.backgroundColor = color
        self.verticalLeft.backgroundColor = color
        self.verticalRight.backgroundColor = color
        
        self.addSubview(self.horizontalTop)
        self.addSubview(self.horizontalBottom)
        self.addSubview(self.verticalLeft)
        self.addSubview(self.verticalRight)
    }
    
    public override func updateContent() {
        let horizontal = frame.height / 3
        let vertical = frame.width / 3
        
        self.horizontalTop.frame = .init(x: 0, y: horizontal, width: frame.width, height: cornerRadius)
        self.horizontalBottom.frame = .init(x: 0, y: horizontal * 2, width: frame.width, height: cornerRadius)
        self.verticalLeft.frame = .init(x: vertical, y: 0, width: cornerRadius, height: frame.height)
        self.verticalRight.frame = .init(x: vertical * 2, y: 0, width: cornerRadius, height: frame.height)
    }
    
}
