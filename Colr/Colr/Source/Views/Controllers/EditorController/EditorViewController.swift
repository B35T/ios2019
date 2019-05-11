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
    @IBOutlet weak var underImageView: UIImageView!
    @IBOutlet weak var closeBtn: CloseButton!
    @IBOutlet weak var saveBtn: SaveButton!
    @IBOutlet weak var label: PresetLabel!
    @IBOutlet weak var presetlabel: PresetLabel!
    @IBOutlet weak var background: UIView!

    var HSLmodelValue: HSLModel? = HSLModel()
    var ProcessEngineProfile: ProcessEngineProfileModel? = ProcessEngineProfileModel()
    var Engine:ProcessEngine!
    var thumbnail:[UIImage]!
    var original:UIImage!
    
    var selectMenu: Int = 0
    var section:Int = 2
    
    
    var cells:MenuCell!
    private var ciimage:CIImage?
    private var image: UIImage? {
        didSet {
            if let img = image {
                self.underImageView.image = img
                self.imageView.image = img
                self.ciimage = CIImage(image: img)
                self.value = (1.0, "none")
                OverlayValue.shared.label.alpha = 0
                self.HSLmodelValue = HSLModel()
                self.ProcessEngineProfile = ProcessEngineProfileModel()
                
                // menu cell
                self.selected = .filter
                self.cells.select = 0
                self.cells.collectionView.reloadData()
                
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
                    self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
                }, completion: nil)
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
    
    var value: (CGFloat, String) = (1.0 , "none") {
        didSet {
            self.imageView.alpha = self.value.0
            OverlayValue.shared.showOverlay(view: self.view, value: self.value.0, center: self.imageView.center)
            self.presetlabel.text = "\(self.value.1) / 𝜶 \(String(format: "%0.0f", self.value.0 * 100))%"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
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

        self.underImageView = imageView
        self.view.addSubview(underImageView)
        
        let imageView2 = UIImageView(frame: .init(x: 0, y: 0, width: view.w, height: view.h.persen(p: 76)))
        imageView2.contentMode = .scaleAspectFit
        self.imageView = imageView2
        self.underImageView.isUserInteractionEnabled = true
        self.underImageView.addSubview(self.imageView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panUpper(_:)))
        self.underImageView.addGestureRecognizer(pan)
        
        
        let closeBtn = CloseButton()
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: 10))
        self.closeBtn = closeBtn
        
        let saveBtn = SaveButton()
        saveBtn.add(view: view, .init(x: view.w.minus(n: 120), y: 10))
        self.saveBtn = saveBtn
        
        let presetlabel = PresetLabel()
        presetlabel.add(view: view, .init(x: 0, y: view.h.persen(p: 70)))
        presetlabel.center.x = self.view.center.x
        self.presetlabel = presetlabel
        self.presetlabel.text = "none / 𝜶 100%"
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
            self.imageView.image = nil
            self.underImageView.image = nil
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
            HSL.prevoidimage = self.imageView.image
            HSL.profile = ProcessEngineProfile
            HSL.HSLModelValue = self.HSLmodelValue
            HSL.image = self.image
            HSL.modalPresentationStyle = .overCurrentContext
            self.imageView.scale(view: view, persen: 50, duration: 0.2)
            self.underImageView.scale(view: view, persen: 50, duration: 0.2)
            self.closeBtn.animatedHidden()
            self.saveBtn.animatedHidden()
        }
        
        if segue.identifier == "overlay" {
            guard let overlay = segue.destination as? OverlayViewController else {return}
            overlay.delegate = self
        }
    }
}

extension EditorViewController: PresetCellDelegate, HSLViewControllerDelegate, FilterCellDelegate, MenuCellDelegate, CropViewControllerDelegate {
    func HSLResult(image: UIImage?, model: HSLModel?) {
        guard let ciimage = self.ciimage else {return}
        self.HSLmodelValue = model
        self.ProcessEngineProfile?.HSL = model
        
        let result = Engine.toolCreate(ciimage: ciimage, Profile: self.ProcessEngineProfile)
        self.imageView.image = UIImage(ciImage: result!)
    }
    func HSLViewBack() {
        self.imageView.scale(view: view, persen: 76, duration: 0.3)
        self.underImageView.scale(view: view, persen: 76, duration: 0.3)
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
            self.ProcessEngineProfile?.filter = nil
            let filter = Engine.toolCreate(ciimage: ciimage!, Profile: self.ProcessEngineProfile)
            self.imageView.image = UIImage(ciImage: filter!)
        case 1:
            self.ProcessEngineProfile?.filter = indexPath.item
            let filter = Engine.toolCreate(ciimage: ciimage!, Profile: self.ProcessEngineProfile)
            self.imageView.image = UIImage(ciImage: filter!)
            self.value = (1.0, "\(identifier)\(indexPath.item)")
            OverlayValue.shared.hidden()
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
//        case 1:
//            self.selected = .preset
//            self.animetion()
        case 1:
            self.performSegue(withIdentifier: "HSL2", sender: nil)
        case 2:
            self.selected = .tools
            self.animetion()
//        case 5:
//            self.performSegue(withIdentifier: "overlay", sender: nil)
        case 4:
            self.performSegue(withIdentifier: "CropPage", sender: nil)
        default:
            break
        }
    }
    
    
    // crop
    func cropResult(image: UIImage, zone: CGRect) {
        guard let ciimage = CIImage(image: image) else {return}
        guard let result = self.Engine.toolCreate(ciimage: ciimage, Profile: self.ProcessEngineProfile) else {return}
        
        self.ciimage = ciimage
        self.underImageView.image = image
        self.imageView.image = UIImage(ciImage: result)
        
    }
    
}

extension EditorViewController {
    @objc internal func panUpper(_ sender: UIPanGestureRecognizer) {
        guard let _ = sender.view else {return}
        let translation = sender.translation(in: self.view)
        
        self.value.0 += (-translation.y / self.view.frame.height)
        
        if self.value.0 >= 1 {
            self.value.0 = 1
        } else if value.0 <= 0 {
            self.value.0 = 0
        }
        
        switch sender.state {
        case .ended:
            OverlayValue.shared.hidden()
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
}

extension EditorViewController: OverlayViewControllerDelegate {
    func OverlaySelected(image: UIImage) {
        let over = OverlayImage()
        over.overlay(view: self.imageView, image: image)
        over.isUserInteractionEnabled = true
        
        let move = UIPanGestureRecognizer(target: self, action: #selector(moveOverlay))
        over.addGestureRecognizer(move)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationOverlay(_:)))
        over.addGestureRecognizer(rotation)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchOverlay(_:)))
        over.addGestureRecognizer(pinch)
        
        let remove = UILongPressGestureRecognizer(target: self, action: #selector(removeOverlay(_:)))
        remove.minimumPressDuration = 1
        over.addGestureRecognizer(remove)
    }
    
    func overlayshow(view: UIView, width:CGFloat = 3, color: UIColor = .white, radius: CGFloat = 4, state: UIGestureRecognizer.State) {
        
        switch state {
        case .changed:
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
            view.layer.cornerRadius = radius
        case .ended:
            view.layer.borderWidth = 0
        default:
            view.layer.borderWidth = 0
        }
        
    }
    
    @objc internal func removeOverlay(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            view.removeFromSuperview()
        }
    }
    
    @objc internal func pinchOverlay(_ sender:UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
    
    @objc internal func rotationOverlay(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc internal func moveOverlay(_ sender: UIPanGestureRecognizer) {
        if let view = sender.view {
            let t = sender.translation(in: self.imageView)
            view.center = .init(x: view.center.x + t.x, y: view.center.y + t.y)
        }
        sender.setTranslation(.zero, in: self.imageView)
    }
}

extension EditorViewController: LightCollectCellDelegate {
    func lightAction(title: String, tag: Int, value: Float, profile: ProcessEngineProfileModel?) {
        let result = Engine.toolCreate(ciimage: self.ciimage!, Profile: profile)
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

