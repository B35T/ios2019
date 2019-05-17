//
//  EditorViewControllers.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class EditorViewControllers: Editor {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeBtn:UIButton!
    @IBOutlet weak var saveBtn:UIButton!
    
    var ciimage: CIImage?
    
    let preset = PresetLibrary()
    var index:IndexPath?
    public var asset: PHAsset? {
        didSet {
            if let asset = asset {
                PHImageManager.default().requestImage(for: asset, targetSize: self.size, contentMode: .aspectFit, options: nil) { (image, _) in
                    guard let image = image else {return}
                    self.imagePreview.image = image
                    
                    self.ciimage = CIImage(image: image)
                    self.collectionView.reloadData()
                }
                self.index = nil
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        
        let closeBtn = UIButton()
        self.closeBtn = closeBtn
        self.closeBtn.frame = .init(x: 10, y: 5, width: 35, height: 35)
        self.closeBtn.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(dismissBack), for: .touchUpInside)
        self.view.addSubview(self.closeBtn)
        
        let seveBtn = UIButton()
        self.saveBtn = seveBtn
        self.saveBtn.frame = .init(x: view.frame.width - 70, y: 5, width: 60, height: 35)
        self.saveBtn.setTitle("Save", for: .normal)
        self.saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.saveBtn.addTarget(self, action: #selector(saveExportImage), for: .touchUpInside)
        self.view.addSubview(self.saveBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "PresetCell", bundle: nil), forCellWithReuseIdentifier: "PresetCell")
        self.collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.frame = .init(x: 0, y: view.frame.height - 160, width: view.frame.width, height: 160)
    }
    
    @objc internal func dismissBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func saveExportImage() {
        guard let asset = asset else {return}
        guard let index = index else {return}
        PHImageManager.default().requestImageData(for: asset, options: nil) { (data, str, oriatation, info) in
            guard let data = data else {return}
            if let image = UIImage(data: data) {
                if let result = self.preset.filter(indexPath: index, ciimage: CIImage(image: image))?.RanderImage {
                    UIImageWriteToSavedPhotosAlbum(result, nil, nil, nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Crop" {
            guard let crop = segue.destination as? CropViewController else {return}
            guard let asset = asset else {return}
            crop.asset = asset
        }
    }
}

extension EditorViewControllers: PresetCellDelegate, MenuCellDelegate {
    func PresetDidSelect(indexPath: IndexPath) {
        guard let ciimage = ciimage else {return}
        self.index = indexPath
        if let result = preset.filter(indexPath: indexPath, ciimage: ciimage) {
            self.imagePreview.top = UIImage(ciImage: result)
        }
    }
    
    func MenuDidSelect(indexPath: IndexPath) {
        switch indexPath.item {
        case 5:
            self.performSegue(withIdentifier: "Crop", sender: nil)
        default:
            break
        }
    }
}
