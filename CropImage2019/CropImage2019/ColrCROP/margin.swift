//
//  margin.swift
//  CropImage2019
//
//  Created by chaloemphong on 29/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class margin: view {
    
    var origin: CGPoint = .zero {
        didSet {
            self.frame.origin = self.origin
        }
    }
    
    var size: CGSize = .zero {
        didSet {
            self.frame.size = self.size
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.height / 2
        self.backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func add_icon() {
        let imageview = UIImageView()
        imageview.frame = .init(x: 0, y: 0, width: 20, height: 20)
        imageview.layer.cornerRadius = 10
        imageview.image = #imageLiteral(resourceName: "move")
        self.addSubview(imageview)
    }
}
