//
//  ViewController.swift
//  FLIM_MAC
//
//  Created by chaloemphong on 16/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageA: NSImageView!
    
    @IBOutlet weak var imageB: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer?.backgroundColor = .white
        self.title = "FLIM Creator for mac"
        self.view.frame.size = .init(width: 1500, height: 1000)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    

}

