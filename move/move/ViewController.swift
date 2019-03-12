//
//  ViewController.swift
//  move
//
//  Created by chaloemphong on 6/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var collectionViewLayer: UICollectionView!
    @IBOutlet weak var add: UIBarButtonItem!
    @IBOutlet weak var addimage: UIBarButtonItem!
    
    var layers :[Int:UIView] = [:]
    var collecLayer: [Int:UIView] = [:]
    var tag = 0
    var tagFind = 0
    let imgs = ["rainbow.png", "rainbow02.png"]
    
    override func loadView() {
        super.loadView()
        
        let imageView = UIImageView(frame: view.frame)
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        self.view.addSubview(self.imageView)
        
        let slider = UISlider(frame: .init(x: 10, y: view.frame.height - 100, width: view.frame.width - 20, height: 20))
        self.slider = slider
        self.slider.minimumValue = 0
        self.slider.maximumValue = 1
        self.slider.value = 1
        self.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
        self.view.addSubview(self.slider)
        
        self.collectionViewLayer.frame = .init(x: view.frame.width - 100, y: 100, width: 100, height: view.frame.height - 200)
        self.collectionViewLayer.backgroundColor = .clear
        self.collectionViewLayer.delegate = self
        self.collectionViewLayer.dataSource = self
        self.view.addSubview(self.collectionViewLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.collectionViewLayer.register(UINib(nibName: "LayerCell", bundle: nil), forCellWithReuseIdentifier: "LayerCell")
    }
    
    @objc internal func sliderAction(_ sender:UISlider) {
        guard let v = self.layers[self.tagFind] as? UIImageView else {return}
        v.alpha = CGFloat(sender.value)
        
        if let c = self.collecLayer[self.tagFind], c.tag == self.tagFind {
            c.alpha = CGFloat(sender.value)
        }
    }
    
    @IBAction func addimageAction(_ sender: Any) {
        pickerPopUp()
    }
    
    @IBAction func addaction(_ sender: Any) {
        let l = self.addlayer(self.imageView)
        layers.updateValue(l, forKey: self.tag)
        tag += 1
        

        self.collectionViewLayer.insertItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    @objc internal func move(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
        
            
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc internal func pinch(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    @objc internal func rotation(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc internal func tapRemove(_ sender: UILongPressGestureRecognizer) {
        if let view = sender.view {
            layers.removeValue(forKey: view.tag)
            self.collectionViewLayer.reloadData()
            view.removeFromSuperview()
        }
    }
    
    @objc internal func tapChoose(_ sender: UITapGestureRecognizer) {
        let pre = self.tagFind
        if let v = self.layers[pre] {
            v.layer.borderWidth = 0
        }
        
        if let view = sender.view as? UIImageView {
            self.tagFind = view.tag
            self.slider.value = Float(view.alpha)
            
            print("choose \(self.tagFind)")
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 3
            
           
        }
    }
    
    @objc internal func pickerPopUp() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError() }
        
        self.imageView.image = image
        self.imageView.isUserInteractionEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
}


extension ViewController {
    func layer(imageview: UIImageView) {
        guard let s = imageview.image else {return}
        
        let c = UIImageView()
        c.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
        var f = CGSize.zero
        if s.size.width > s.size.height {
            let calculator = imageview.frame.width / s.size.width * imageview.frame.height
            f = .init(width: imageview.frame.width, height: calculator)
        } else {
            let calculator = imageview.frame.height / s.size.height * imageview.frame.height
            f = .init(width: calculator, height: imageview.frame.height)
        }
        
        c.center = .init(x: imageview.center.x - (f.width / 2), y: imageview.center.y - (f.height / 2))
        c.frame.size = f
        imageview.addSubview(c)
    }
    
    func addlayer(_ view:UIView) -> UIView {
        
        let label = UILabel()
        label.frame = .init(x: -10, y: -10, width: 20, height: 20)
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        
        let image = UIImageView(frame: .zero)
        image.tag = tag
        label.text = "\(tag)"
        self.tagFind = tag
        image.frame.size = .init(width: 200, height: 200)
        image.frame.origin = .init(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 100)
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: self.imgs.randomElement() ?? "rainbow.png")
        view.addSubview(image)
        image.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapChoose(_:)))
        let tapLong = UILongPressGestureRecognizer(target: self, action: #selector(tapRemove(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotation(_:)))
        image.addGestureRecognizer(tapLong)
        image.addGestureRecognizer(tap)
        image.addGestureRecognizer(pinch)
        image.addGestureRecognizer(rotation)
        image.addGestureRecognizer(pan)
        image.isUserInteractionEnabled = true
        
        
        return image
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pre = self.tagFind
        if let v = self.layers[pre] {
            v.layer.borderWidth = 0
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayerCell", for: indexPath) as! LayerCell
        self.tagFind = cell.tag
        print("_\(cell.tag)")
        
        
        if let view = self.layers[self.tagFind] as? UIImageView {
            self.tagFind = view.tag
            self.slider.value = Float(view.alpha)
            
            print("choose \(self.tagFind)")
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 3
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayerCell", for: indexPath) as! LayerCell
        cell.backgroundColor = .red
        self.collecLayer.updateValue(cell, forKey: self.tagFind)
        cell.tag = self.tagFind
        cell.thumbnail = UIImage(named: "rainbow.png")
        print("tag")
        print(self.tag)
        print("_")
        return cell
    }
}
