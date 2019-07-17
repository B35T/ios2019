//
//  LoadViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol CatalogViewControllerDelegate {
    func dismissCatalog(action:Bool)
}

class CatalogViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!

    var preview: PreviewCatalogViewController?
    
    let model = PresetModels()
    var delegate: CatalogViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preview = self.storyboard?.instantiateViewController(withIdentifier: "preview_catalog") as? PreviewCatalogViewController
        self.preview?.delegate = self
        
        collectionView.frame = .init(x: 0, y: appDefualt.shared.positionC, width: view.frame.width, height: view.frame.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black

        self.view.backgroundColor = .black
        
        let backBtn = UIButton()
        self.backBtn = backBtn
        self.backBtn.frame = .init(x: 5, y: 30, width: 76, height: 35)
        self.backBtn.setBackgroundImage(UIImage(named: "back.png"), for: .normal)
        self.backBtn.layer.cornerRadius = 15
        self.backBtn.clipsToBounds = true
        self.backBtn.layer.compositingFilter = "screenBlendMode"
        self.backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view.addSubview(self.backBtn)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func back() {
        self.delegate?.dismissCatalog(action: false)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CatalogViewController: PreviewCatalogViewControllerDelegate {
    func PreviewBackAction() {
        self.backBtn.alpha = 1
        if let select = self.collectionView.indexPathsForSelectedItems {
            self.collectionView.isScrollEnabled = true
            self.collectionView.reloadItems(at: select)
        }
    }
    
    func PreviewChooseAction(item:String?) {
        
        if let item = item {
            UserDefaults.standard.set(item, forKey: "styles")
        }
        self.delegate?.dismissCatalog(action: true)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CatalogViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.backBtn.alpha = 0
        
        let item = self.model.item[indexPath.item]
        
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.superview?.bringSubviewToFront(cell)
        
        if let vc = self.preview {
            vc.rect = cell.frame
            cell.addSubview(vc.view)
            vc.view.alpha = 1
            vc.collectionView.alpha = 1
            vc.item = item
            
            UIView.animate(withDuration: 0.2) {
                cell.frame = collectionView.bounds
                self.collectionView.isScrollEnabled = false
                
                vc.view.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                vc.collectionView.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                
            }
        }
        
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preview", for: indexPath) as! ImageCell
        
        cell.imageview.contentMode = .scaleAspectFill
        cell.imageview.layer.cornerRadius = 4
        cell.imageview.clipsToBounds = true
        
        cell.imageview.image = UIImage(named: "\(self.model.item[indexPath.item])_0.jpg")
        return cell
    }
    
    
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return .init(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: appDefualt.shared.positionB, height: appDefualt.shared.positionB)
    }
}
