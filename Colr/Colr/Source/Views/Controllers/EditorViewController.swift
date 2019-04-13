//
//  EditorViewController.swift
//  Colr
//
//  Created by chaloemphong on 21/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

class EditorViewController: UIViewController {

    var asset: PHAsset!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtn: CloseButton!
    @IBOutlet weak var saveBtn: SaveButton!
    @IBOutlet weak var label: PresetLabel!
    var HSLmodelValue: HSLModel? = HSLModel()
    var Engine:ProcessEngine!
    
    var selectMenu: Int = 0
    
    private var image: UIImage? {
        didSet {
            if let img = image {
                self.imageView.image = img
            } else {
                print("no image")
            }
        }
    }
    
    enum Cells: String {
        case PresetCell
        case MenuCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Engine = ProcessEngine()
        self.collectionView.register(UINib(nibName: Cells.PresetCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.PresetCell.rawValue)
        self.collectionView.register(UINib(nibName: Cells.MenuCell.rawValue, bundle: nil), forCellWithReuseIdentifier: Cells.MenuCell.rawValue)
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
        
        let presetLabel = PresetLabel()
        presetLabel.add(view: view, .init(x: 0, y: view.h.minus(n: 200)))
        presetLabel.x(view: view)
        presetLabel.text = "OG \\ 100"
        self.label = presetLabel
        
        
        
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
            self.label.animatedHidden()
        }
    }
}

extension EditorViewController: PresetCellDelegate, MenuCellDelegate, CropViewControllerDelegate, HSLViewControllerDelegate {
    func HSLResult(image: UIImage?, model: HSLModel?) {
        self.imageView.image = image
        self.HSLmodelValue = model
    }
    
    func HSLViewBack() {
        self.imageView.scale(view: view, persen: 76, duration: 0.3)
        self.closeBtn.animatedHidden(action: false)
        self.saveBtn.animatedHidden(action: false)
        self.label.animatedHidden(action: false)
    }
    
    func PresetSelectItem(indexPath: IndexPath, identifier: String) {
        if identifier == "OG" {
            self.label.text = "OG"
            return
        }
        self.label.text = "\(identifier)\(indexPath.item) \\ 100"
    }
    
    func MenuCellSelected(indexPath: IndexPath) {
        switch indexPath.item {
        case 1:
            self.performSegue(withIdentifier: "HSL", sender: nil)
            
        case 5:
            self.performSegue(withIdentifier: "CropPage", sender: nil)
        default:
            break
        }
    }
    
    func cropResult(image: UIImage, zone: CGRect) {
        self.image = image
    }
    
}

extension EditorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.PresetCell.rawValue, for: indexPath) as! PresetCell
            cell.delegate = self
            let s = 60 * UIScreen.main.scale
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: s, height: s), contentMode: .default, options: nil) { (img, _) in
                cell.thumbnails = img
            }
            cell.asset = asset
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.MenuCell.rawValue, for: indexPath) as! MenuCell
            cell.delegate = self
            cell.images = [#imageLiteral(resourceName: "preset"), #imageLiteral(resourceName: "hsl"), #imageLiteral(resourceName: "light"), #imageLiteral(resourceName: "3d"), #imageLiteral(resourceName: "overlay"), #imageLiteral(resourceName: "crop")]
            return cell
        default:
            fatalError()
        }
    }
}

extension EditorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
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
