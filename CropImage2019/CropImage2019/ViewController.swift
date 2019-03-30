//
//  ViewController.swift
//  CropImage2019
//
//  Created by chaloemphong on 27/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


class ViewController: ColrCROPViewController {
    
    
    @IBOutlet weak var free: UIButton!
    @IBOutlet weak var sq: UIButton!
    @IBOutlet weak var imagescale: UIButton!
    @IBOutlet weak var add: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.view.insertSubview(self.free, at: 5)
        self.view.insertSubview(self.imagescale, at: 5)
        self.view.insertSubview(self.sq, at: 5)
        self.view.insertSubview(self.add, at: 5)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func PickerImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func freeAction(_ sender: Any) {
        self.Scale = .free
    }
    
    @IBAction func sqAction(_ sender: Any) {
        self.Scale = .sq
    }
    
    @IBAction func imageAction(_ sender: Any) {
        self.Scale = .image
    }
    
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
