//
//  ViewController.swift
//  rotation
//
//  Created by chaloemphong on 10/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func loadView() {
        super.loadView()

        let scrollView = UIScrollView(frame: .init(x: 20, y: 40, width: view.bounds.width - 40, height: view.bounds.height - 200))
        self.scrollView = scrollView
        self.view.addSubview(self.scrollView)
        
        let imageView = UIImageView(frame: .init(origin: .zero, size: scrollView.bounds.size))
        self.imageView = imageView
        self.scrollView.addSubview(self.imageView)
        
        self.imageView.backgroundColor = .red
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sliderAction(_ sender: Any) {
        
    }
    
}

