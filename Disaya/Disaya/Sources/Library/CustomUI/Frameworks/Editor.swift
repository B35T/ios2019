//
//  Editor.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

open class Editor: UIViewController {
    
    var imagePreview: Preview!
    
    var size: CGSize {
        return .init(width: view.frame.width * UIScreen.main.scale, height: view.frame.height * UIScreen.main.scale)
    }
    
    override open func loadView() {
        super.loadView()
        
        let imagePreview = Preview(frame: .init(x: 0, y: 40, width: view.frame.width, height: (view.frame.height / 100 * 73) - 40))
        self.imagePreview = imagePreview
        self.view.addSubview(self.imagePreview)
        
     
        self.view.backgroundColor = .black
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
 
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
