//
//  EditorViewController.swift
//  Colr
//
//  Created by chaloemphong on 21/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(close))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc internal func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
