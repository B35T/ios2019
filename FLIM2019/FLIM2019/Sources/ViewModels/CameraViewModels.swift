//
//  CameraViewModels.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class CameraViewModels: UIViewController {

    
    override open func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .black
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }

}
