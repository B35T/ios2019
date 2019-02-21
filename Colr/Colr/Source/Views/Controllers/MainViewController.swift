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
        _ = self.count
        
        self.collection.reloadData()
    }


}

