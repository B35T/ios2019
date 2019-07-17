//
//  AllowView.swift
//  FLIM2019
//
//  Created by chaloemphong on 16/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class AllowView: UIView {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var pickerBtn: UIButton!
    var vc: UIViewController?
    let preset = PresetModels()
    
    open func initialize(view: UIView, title:String = "Allow Access To Photos And Camera") {

        self.frame = view.frame
        self.backgroundColor = .white
        
        let btn = UIButton()
        self.btn = btn
        self.btn.frame.size = .init(width: view.frame.width - 20, height: 55)
        self.btn.center = self.center
        self.btn.backgroundColor = blue
        self.btn.setTitle(title, for: .normal)
        self.btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        self.btn.setTitleColor(.white, for: .normal)
        self.btn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        self.btn.layer.cornerRadius = 4
        self.btn.clipsToBounds = true
        self.addSubview(self.btn)
        
        let pickerBtn = UIButton()
        self.pickerBtn = pickerBtn
        self.pickerBtn.frame = .init(x: 0, y: 50, width: 100, height: 50)
        self.pickerBtn.setTitle("picker", for: .normal)
        self.pickerBtn.setTitleColor(blue, for: .normal)
        self.pickerBtn.addTarget(self, action: #selector(pickerAction), for: .touchUpInside)
//        self.addSubview(self.pickerBtn)
        
        view.addSubview(self)
    }
    
    @objc internal func pickerAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        vc?.present(imagePicker, animated: true, completion: nil)

    }
    
    @objc internal func btnAction() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension AllowView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let ciimage = CIImage(image: image) {
            if let result = self.preset.creator(ciimage: ciimage, item: .item5)?.toCGImage {
                let img = UIImage(cgImage: result)
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
