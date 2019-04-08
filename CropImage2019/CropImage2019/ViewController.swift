//
//  ViewController.swift
//  CropImage2019
//
//  Created by chaloemphong on 27/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


class ViewController: ColrCROPViewController {
    
    
    @IBOutlet weak var cropBtn: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black

        self.collection.delegate = self
        self.collection.dataSource = self
        self.view.insertSubview(self.collection, at: 5)
        self.view.insertSubview(self.add, at: 5)
        self.view.insertSubview(self.cropBtn, at: 5)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cropAction(_ sender: Any) {
        guard let crop = self.cropping() else {return}
        UIImageWriteToSavedPhotosAlbum(crop, nil, nil, nil)
    }
    
    @IBAction func PickerImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.scaleRatio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ViewCell
        cell.label.text = self.scaleRatio.title(i: indexPath.item)
        return cell
    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scaleRatio = setScale(rawValue: indexPath.item) ?? setScale.free
        print(setScale(rawValue: indexPath.item) ?? setScale.free)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
