//
//  imageview.swift
//  CropImage2019
//
//  Created by chaloemphong on 8/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class imageScrollView: view {
    
    @IBOutlet open weak var scrollview: UIScrollView!
    @IBOutlet open weak var imageview: UIImageView!
    
    public var image:UIImage? = nil {
        didSet {
            if let img = image {
                self.imageview.image = img
            }
        }
    }

    override var rect: CGRect {
        didSet {
            let r = self.imageview.calculetorImageFrame(frame: self.rect)
            self.frame = r
            self.scrollview.frame.size = r.size
            self.imageview.frame.size = r.size
        }
    }
    
    public override func config() {
        super.config()
        
        let scrollview = UIScrollView(frame: .zero)
        self.scrollview = scrollview
        self.addSubview(self.scrollview)
        
        let imageview = UIImageView(frame: .zero)
        self.imageview = imageview
        self.imageview.contentMode = .scaleAspectFit
        self.imageview.clipsToBounds = true
        self.addSubview(self.imageview)
    }
}
