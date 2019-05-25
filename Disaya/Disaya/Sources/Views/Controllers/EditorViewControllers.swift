//
//  EditorViewControllers.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

var device: CGFloat {
    if UIScreen.main.bounds.height > 736 {
        return 200
    } else {
        return 160
    }
}

class EditorViewControllers: Editor {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeBtn:UIButton!
    @IBOutlet weak var saveBtn:UIButton!
    
    var ciimage: CIImage?
    var profile = DisayaProfile.shared
    
    var cropData:(CGRect?, Float?, CGSize?)
    let preset = PresetLibrary()
    var index:IndexPath? {
        didSet{
            self.profile.filter = self.index
        }
    }
    public var asset: PHAsset? {
        didSet {
            if let asset = asset {
                PHImageManager.default().requestImage(for: asset, targetSize: self.size, contentMode: .aspectFit, options: nil) { (image, _) in
                    guard let image = image else {return}
                    print(image.size)
                    self.cropData.2 = image.size
                    self.imagePreview.image = image
                    
                    self.ciimage = CIImage(image: image)
                    self.collectionView.reloadData()
                }
                self.index = nil
            }
        }
    }
    
    var selected:select = .filter
    var selectedTool:IndexPath?
    var coll:UICollectionView?
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
        
        self.collectionView.register(UINib(nibName: "LightCollectCell", bundle: nil), forCellWithReuseIdentifier: "LightCollectCell")
        self.collectionView.register(UINib(nibName: "PresetCell", bundle: nil), forCellWithReuseIdentifier: "PresetCell")
        self.collectionView.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.frame = .init(x: 0, y: view.frame.height - device, width: view.frame.width, height: 160)
    }
    
    @objc internal func dismissBack() {
        self.dismiss(animated: true, completion: nil)
    }
    func cropMultiply(ago:CGSize, new:CGSize, cropData:CGRect) -> CGRect {
        let c = Swift.max(new.width / ago.width, new.height / ago.height)
        let crop = CGRect(x: cropData.origin.x * c, y: cropData.origin.y * c, width: cropData.width * c, height: cropData.height * c)
        return crop
        
    }
    
    @objc internal func saveExportImage() {
        guard let asset = asset else {return}
        guard let index = index else {return}
        
        PHImageManager.default().requestImageData(for: asset, options: nil) { (data, str, or, info) in
            guard let ciimage = CIImage(data: data!) else {return}
            
            if self.cropData.0 != nil && self.cropData.1 != 0 {
                let filter = CIFilter(name: "CIStraightenFilter")
                filter?.setDefaults()
                filter?.setValue(ciimage, forKey: "inputImage")
                filter?.setValue(self.cropData.1, forKey: "inputAngle")
                
                let rect = self.cropMultiply(ago: self.cropData.2!, new: ciimage.extent.size, cropData: self.cropData.0!)
                if let result = self.preset.filter(indexPath: index, ciimage: filter?.outputImage!)?.toCGImage?.cropping(to: rect) {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
                
            } else if self.cropData.1 == 0 && self.cropData.0 != nil {
                let rect = self.cropMultiply(ago: self.cropData.2!, new: ciimage.extent.size, cropData: self.cropData.0!)
                if let result = self.preset.filter(indexPath: index, ciimage: ciimage)?.toCGImage?.cropping(to: rect) {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
            } else {
                if let result = self.preset.filter(indexPath: index, ciimage: ciimage)?.toCGImage {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Crop" {
            guard let crop = segue.destination as? CropViewController else {return}
            guard let asset = asset else {return}
            crop.delegate = self
            crop.asset = asset
        }
        
        if segue.identifier == "HSL" {
            guard let HSL = segue.destination as? HSLViewController else {return}
            HSL.profile = self.profile
            HSL.delegate = self
            HSL.modalPresentationStyle = .overCurrentContext
            
            self.closeBtn.alpha = 0
            self.saveBtn.alpha = 0
            self.imagePreview.scale(h: view.frame.height, minus: 370, y: 10)
        }
        
        if segue.identifier == "LightSlider" {
            guard let slider = segue.destination as? LightSliderViewController else {return}
            slider.modalPresentationStyle = .overCurrentContext
            slider.delegate = self
            slider.title = self.title
            slider.type = .A
            slider.selectedTool = self.selectedTool
        }
    }
}

extension EditorViewControllers: HSLViewControllerDelegate, CropViewControllerDelegate {
    func cropResult(imageSize: CGSize, zone: CGRect, straighten: Float) {
        PHImageManager.default().requestImage(for: asset!, targetSize: self.size, contentMode: .aspectFit, options: nil) { (image, _) in
           
            guard let image = image else {return}
            if straighten != 0 {
                guard let ciimage = CIImage(image: image) else {return}
                let filter = CIFilter(name: "CIStraightenFilter")
                
                filter?.setDefaults()
                filter?.setValue(ciimage, forKey: "inputImage")
                filter?.setValue(straighten, forKey: "inputAngle")
                let size = filter!.outputImage!.RanderImage
                
                let min = Swift.max(size!.size.width / imageSize.width , size!.size.height / imageSize.height)
                let cropZone = CGRect(x: zone.origin.x * min, y: zone.origin.y * min, width: zone.width * min, height: zone.height * min)
                
                guard let result = size?.cgImage?.cropping(to: cropZone) else {return}
                let i = UIImage(cgImage: result)
                self.ciimage = CIImage(image: i)
                if self.profile.filter != nil {
                    self.imagePreview.top = self.preset.toolCreate(ciimage: self.ciimage!, Profile: self.profile)?.RanderImage
                    self.imagePreview.bottom = i
                } else {
                    self.imagePreview.image = i
                }
                
                self.cropData.0 = cropZone
                self.cropData.1 = straighten
            } else {
                let min = Swift.max(image.size.width / imageSize.width , image.size.height / imageSize.height)
                let cropZone = CGRect(x: zone.origin.x * min, y: zone.origin.y * min, width: zone.width * min, height: zone.height * min)
                guard let result = image.cgImage?.cropping(to: cropZone) else {return}
                let i = UIImage(cgImage: result)
                self.ciimage = CIImage(image: i)
                if self.profile.filter != nil {
                    self.imagePreview.image = self.preset.toolCreate(ciimage: self.ciimage!, Profile: self.profile)?.RanderImage
                    self.imagePreview.bottom = i
                } else {
                    self.imagePreview.image = i
                }
                
                self.cropData.0 = cropZone
                self.cropData.1 = 0
            }
        }
    }
    
    func HSLResult(model: DisayaProfile?) {
        guard let result = self.preset.toolCreate(ciimage: self.ciimage!, Profile: model) else {print("no image");return}
        self.imagePreview.top = UIImage(ciImage: result)
    }
    
    func HSLShow(action: Bool) {
        if !action {
            self.imagePreview.scale(from: view.frame.height, persen: 69, duration: 0.2, y: 40)
            self.closeBtn.alpha = 1
            self.saveBtn.alpha = 1
        }
    }
}

extension EditorViewControllers: PresetCellDelegate, MenuCellDelegate {
    func PresetDidSelect(indexPath: IndexPath) {
        guard let ciimage = ciimage else {return}
        self.index = indexPath
        guard let result = self.preset.toolCreate(ciimage: ciimage, Profile: self.profile) else {return}
        self.imagePreview.top = UIImage(ciImage: result)
    }
    
    func MenuDidSelect(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            if self.selected == .preset { return }
            self.selected = .preset
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
                self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
            }, completion: nil)
        case 2:
            if self.selected == .tools { return }
            self.selected = .tools
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
                self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
            }, completion: nil)
        case 4:
            self.performSegue(withIdentifier: "Crop", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "HSL", sender: nil)
        default:
            break
        }
    }
}

extension EditorViewControllers: LightCellDelegate {
    func LightDidSelect(indexPath: IndexPath, title:String) {
        self.closeBtn.alpha = 0
        self.saveBtn.alpha = 0
        self.selectedTool = indexPath
        self.title = title
        self.performSegue(withIdentifier: "LightSlider", sender: nil)
    }
}

extension EditorViewControllers: LightSliderDelegate {
    func LightSliderTypeA(tag: Int, A: Float?, tool:tool) {
        self.profile.updateTools(t: tool, value: CGFloat(A ?? 0.0))
        guard let image = self.preset.toolCreate(ciimage: self.ciimage!, Profile: self.profile) else {
            print("no image"); return
        }
        self.imagePreview.top = UIImage(ciImage: image)
    }
    
    func LightSliderTypeB(tag: Int, A: Float?, B: Float?, tool:tool) {
        
    }
    
    func LightSliderClose() {
        self.closeBtn.alpha = 1
        self.saveBtn.alpha = 1
    }
    
}
