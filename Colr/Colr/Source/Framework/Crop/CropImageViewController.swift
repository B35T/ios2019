//
//  CropImageViewController.swift
//  Colr
//
//  Created by chaloemphong on 12/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class CropImageViewController: UIViewController {

    @IBOutlet open weak var imageView: UIImageView!
    @IBOutlet open weak var frameView: FrameView!
    
    
    var image:UIImage? {
        didSet {
            if let img = image {
                self.imageView.image = img
                self.frameView.calculator = self.calculator
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        self.view.isUserInteractionEnabled = true
        
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        self.imageView.frame = .init(x: 10, y: 10, width: view.w - 20, height: view.h.persen(p: 80))
        self.imageView.isUserInteractionEnabled = true
        self.view.addSubview(self.imageView)
        
        let frameView = FrameView(frame: .init(x: 0, y: 0, width: view.w - 20, height: view.h.persen(p: 80)))
        
        self.frameView = frameView
        self.imageView.addSubview(self.frameView)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        
    }

    var calculator: CGRect {
        var r:CGRect = .zero
        if let s = image?.size {
            
            let c = s.width / s.height
            let h = self.imageView.w / c
            let y = (imageView.h / 2) - (h / 2)
            
            if h > imageView.h {
                print("B")
                let c = s.height / s.width
                let w = imageView.h / c
                let x = (imageView.w / 2) - (w / 2)
                r = .init(x: x, y: 0, width: w, height: imageView.h)
            } else {
                print("A")
                r = .init(x: 0, y: y, width: imageView.w, height: h)
            }
        }
        print(r)
        return r
    }
}
