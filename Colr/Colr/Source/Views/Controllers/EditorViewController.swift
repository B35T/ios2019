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

    var asset: PHAsset!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: CloseButton!
    @IBOutlet weak var saveBtn: SaveButton!
    @IBOutlet weak var label: PresetLabel!
    var HSLmodelValue: HSLModel? = HSLModel()
    var ProcessEngineProfile: ProcessEngineProfileModel? = ProcessEngineProfileModel()
    var Engine:ProcessEngine!
    var thumbnail:CIImage!
    
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
        case PresetCell
        case MenuCell
        case LightCollectCell
    }
    
    var selected:select = .filter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Engine = ProcessEngine()
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
        
//        let presetLabel = PresetLabel()
        
        self.updateStaticPhotos()
    }
    
    func updateStaticPhotos() {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        
        let s:CGFloat = 1000//UIScreen.main.bounds.width // * UIScreen.main.scale
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: s, height: s), contentMode: .aspectFit, options: option) { (image, _) in
            self.image = image
            self.imageView.image = self.image
            print(image?.size ?? 0.0)
        }
        
        let s2 = 60 * UIScreen.main.scale
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: s2, height: s2), contentMode: .default, options: nil) { (img, _) in
            
            guard let img = img else {return}
            guard let ciimage = CIImage(image: img) else {return}
            self.thumbnail = ciimage
        }
        
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CropPage" {
            guard let croping = segue.destination as? CropViewController else {return}
            guard let asset = self.asset else {return}
            croping.delegate = self
            croping.asset = asset
        }
        
        if segue.identifier == "HSL" {
            guard let HSL = segue.destination as? HSLViewController else {return}
            HSL.delegate = self
            HSL.Engine = self.Engine
            HSL.HSLModelValue = self.HSLmodelValue
            HSL.image = self.image
            HSL.prevoidImg = self.imageView.image
            HSL.modalPresentationStyle = .overCurrentContext
            self.imageView.scale(view: view, persen: 50, duration: 0.2)
            self.closeBtn.animatedHidden()
            self.saveBtn.animatedHidden()
        }
    }
}

extension EditorViewController: PresetCellDelegate, FilterCellDelegate, MenuCellDelegate, CropViewControllerDelegate, HSLViewControllerDelegate {
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
            return self.imageView.image = UIImage(ciImage: thumbnail)
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
        case 2:
            self.performSegue(withIdentifier: "HSL", sender: nil)
            self.remove()
        case 3:
            self.animetion()
        case 6:
            self.performSegue(withIdentifier: "CropPage", sender: nil)
            self.remove()
        default:
            self.remove()
            break
        }
    }
    
    func cropResult(image: UIImage, zone: CGRect) {
        self.image = image
    }
    
}

extension EditorViewController: LightCollectCellDelegate {
    func updateValueProfile(profile: ProcessEngineProfileModel?) {
        self.ProcessEngineProfile = profile
        print(self.ProcessEngineProfile?.white)
        let out = Engine.whitePoint(ciimage: ciimage, point: profile?.white ?? 1)
        self.imageView.image = UIImage(ciImage: out!)
    }
}

extension EditorViewController: UICollectionViewDataSource {
    func animetion() {
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
            self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
        }, completion: nil)
        
    }
    
    func remove() {
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteSections(IndexSet.init(arrayLiteral: 0))
            self.collectionView.insertSections(IndexSet.init(arrayLiteral: 0))
        }, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.selected == .preset {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.LightCollectCell.rawValue, for: indexPath) as! LightCollectCell
            cell.ProcessEngineProfile = self.ProcessEngineProfile
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            switch selected {
            case .filter:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PresetCell.rawValue, for: indexPath) as! FilterCell
                cell.Engine = self.Engine
                cell.delegate = self
                cell.thumbnails = self.thumbnail
                return cell
            case .preset:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PresetCell.rawValue, for: indexPath) as! PresetCell
                cell.Engine = self.Engine
                cell.delegate = self
                cell.thumbnails = self.thumbnail
                return cell
            case .tools:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.LightCollectCell.rawValue, for: indexPath) as! LightCollectCell
                cell.delegate = self
                cell.viewController = self
                cell.tag = indexPath.item
                cell.titles = ["Exposure", "Brightness","Contrast","White","Hue","Grain","Fade","Highlight","Shadow","Saturation","Vibrance","Temperature","Vibrance","Gamma","Tint","Sharpan","Split Tone"]
                cell.ProcessEngineProfile = self.ProcessEngineProfile
                return cell
            }
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MenuCell.rawValue, for: indexPath) as! MenuCell
            cell.delegate = self
            cell.images = [#imageLiteral(resourceName: "Filter"),#imageLiteral(resourceName: "preset"), #imageLiteral(resourceName: "hsl"), #imageLiteral(resourceName: "light"), #imageLiteral(resourceName: "3d"), #imageLiteral(resourceName: "overlay"), #imageLiteral(resourceName: "crop")]
            return cell
        default:
            fatalError()
        }
    }
}

extension EditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension EditorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.w, height: 80)
        default:
            return CGSize(width: view.w, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}



extension EditorViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
}
