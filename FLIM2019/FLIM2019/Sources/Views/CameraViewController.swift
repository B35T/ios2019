//
//  CameraViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class CameraViewController: CameraViewModels {

    @IBOutlet weak var bgTop:UIImageView!
    @IBOutlet weak var bgBottom:UIImageView!
    
    
    override func loadView() {
        super.loadView()
        
        let r = self.view.frame
        
        let bgTop = UIImageView()
        self.bgTop = bgTop
        self.bgTop.frame = .init(x: r.width.persent(70), y: 0, width: r.width.persent(30), height: r.height)
        self.view.addSubview(self.bgTop)
        
        let bgBottom = UIImageView()
        self.bgBottom = bgBottom
        self.bgBottom.frame = .init(x: 0, y: 0, width: r.width.persent(70), height: r.height)
        self.view.addSubview(self.bgBottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgTop.image = UIImage(named: "bgtop.png")
        self.bgBottom.image = UIImage(named: "skin.png")
    }
}
