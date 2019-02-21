//
//  ViewController.swift
//  Colr
//
//  Created by chaloemphong on 19/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class MainViewController: PhotosViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collection.reloadData()
        self.closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(editor), for: .touchUpInside)
        
    }

    @objc internal func close() {
        self.animated(action: false)
        self.closeBtn.animatedHidden()
        self.nextBtn.animatedHidden()
    }
    
    @objc internal func editor() {
        let vc = EditorViewController()
        self.show(vc, sender: nil)
    }
}

