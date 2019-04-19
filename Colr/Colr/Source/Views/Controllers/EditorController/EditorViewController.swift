//
//  EditorViewController.swift
//  Colr
//
//  Created by chaloemphong on 21/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

enum select:Int {
    case filter = 0
    case preset
    case tools
}

class EditorViewController: UIViewController {

    var asset: PHAsset? {
        didSet {
            self.updateStaticPhotos()
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: CloseButton!
    @IBOutlet weak var saveBtn: SaveButton!
    @IBOutlet weak var label: PresetLabel!
    var HSLmodelValue: HSLModel? = HSLModel()
    var ProcessEngineProfile: ProcessEngineProfileModel? = ProcessEngineProfileModel()
    var Engine:ProcessEngine!
    var thumbnail:[UIImage]!
    var original:UIImage!
    
    var selectMenu: Int = 0
    var section:Int = 2
    
    private var ciimage:CIImage?
    private var image: UIImage? {
        didSet {
            if let img = image {
                self.imageView.image = img
                self.ciimage = CIImage(image: img)
            } else {
                print("no image")
            }
        }
    }
    
    enum Cells: String {
        case FilterCell
        case PresetCell
        case MenuCell
        case LightCollectCell
    }
    
    var selected:select = .filter
    var checkSelect:select = .filter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Engine = ProcessEngine()
        self.collectionView.register(UINib(nibName: Cells.FilterCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.FilterCell.rawValue)
        self.collectionView.register(UINib(nibName: Cells.PresetCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.PresetCell.rawValue)
        self.collectionView.register(UINib(nibName: Cells.MenuCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.MenuCell.rawValue)
        self.collectionView.register(UINib(nibName: Cells.LightCollectCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.LightCollectCell.rawValue)
        self.collectionView.frame = .init(x: 0, y: view.h.minus(n: 150), width: view.w, height: 150)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .clear

        PHPhotoLibrary.shared().register(self)
        
        self.view.backgroundColor = .black

        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: view.w, height: view.h.persen(p: 76)))
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        self.view.addSubview(self.imageView)
        
        let closeBtn = CloseButton()
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: 10))
        self.closeBtn = closeBtn
        
        let saveBtn = SaveButton()
        saveBtn.add(view: view, .init(x: view.w.minus(n: 120), y: 10))
        self.saveBtn = saveBtn
        
    }
    
    func updateStaticPhotos() {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        
        let s:CGFloat = 1000//UIScreen.main.bounds.width // * UIScreen.main.scale
        PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: s, height: s), contentMode: .aspectFit, options: option) { (image, _) in
            self.image = image
            self.imageView.image = self.image
            print(image?.size ?? 0.0)
        }
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func closeAction() {
//        self.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CropPage" {
            guard let croping = segue.destination as? CropViewController else {return}
            guard let asset = self.asset else {return}
            croping.delegate = self
            croping.asset = asset
        }
        
        if segue.identifier == "HSL2" {
            guard let HSL = segue.destination as? HSLViewControllers else {return}
            HSL.delegate = self
            HSL.Engine = self.Engine
            HSL.image = self.image
            HSL.prevoidimage = self.imageView.image
            HSL.HSLModelValue = self.HSLmodelValue
            HSL.modalPresentationStyle = .overCurrentContext
            self.imageView.scale(view: view, persen: 50, duration: 0.2)
            self.closeBtn.animatedHidden()
            self.saveBtn.animatedHidden()
        }
    }
}

extension EditorViewController: PresetCellDelegate, HSLViewControllerDelegate, FilterCellDelegate, MenuCellDelegate, CropViewControllerDelegate {
    //HSL
    func HSLResult(image: UIImage?, model: HSLModel?) {
        self.imageView.image = image
        self.HSLmodelValue = model
    }
    
    func HSLViewBack() {
        self.imageView.scale(view: view, persen: 76, duration: 0.3)
        self.closeBtn.animatedHidden(action: false)
        self.saveBtn.animatedHidden(action: false)
    }
    
    // Preset
    func PresetSelectItem(indexPath: IndexPath, identifier: String) {
        
    }
    
    //Filter
    func FilterSelectItem(indexPath: IndexPath, identifier: String) {
        switch indexPath.section {
        case 0:
            return self.imageView.image = self.image
        case 1:
            let filter = Engine.filter(index: indexPath.item, ciimage: ciimage!)
            self.imageView.image = UIImage(ciImage: filter!)
        default:
            break
        }
    }
    
    // Menu
    func MenuCellSelected(indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.selected = .filter
            self.animetion()
        case 1:
            self.selected = .preset
            self.animetion()
        case 2:
            self.performSegue(withIdentifier: "HSL2", sender: nil)
        case 3:
            self.selected = .tools
            self.animetion()
        case 6:
            self.performSegue(withIdentifier: "CropPage", sender: nil)
        default:
            break
        }
    }
    
    func cropResult(image: UIImage, zone: CGRect) {
        self.image = image
    }
    
}

extension EditorViewController: LightCollectCellDelegate {
    func lightAction(title: String, tag: Int, value: Float, profile: ProcessEngineProfileModel?) {
        let result = Engine.toolCreate(t: tool(rawValue: tag)!, ciimage: self.ciimage!, Profile: profile!, value: value)
        self.imageView.image = UIImage(ciImage: result!)
    }

    func updateValueProfile(profile: ProcessEngineProfileModel?) {
        self.ProcessEngineProfile = profile
    }
}



extension EditorViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}

