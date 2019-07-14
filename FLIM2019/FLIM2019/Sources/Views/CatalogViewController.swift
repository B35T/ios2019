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
    
    let items = PresetModels().items
    
    var delegate: CatalogViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black

        self.view.backgroundColor = .black
        
        let backBtn = UIButton()
        self.backBtn = backBtn
        self.backBtn.frame = .init(x: 5, y: 30, width: 70, height: 30)
        self.backBtn.setBackgroundImage(UIImage(named: "back.png"), for: .normal)
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
extension CatalogViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let preset = self.items[indexPath.item]
        
        UserDefaults.standard.set(preset, forKey: "styles")
        
        self.delegate?.dismissCatalog(action: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preview", for: indexPath) as! ImageCell
        
        cell.imageview.contentMode = .scaleAspectFill
        cell.imageview.layer.cornerRadius = 4
        cell.imageview.clipsToBounds = true
        
        cell.imageview.image = UIImage(named: "\(self.items[indexPath.item]).jpg")
        return cell
    }
    
    
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return .init(width: w, height: w / 2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 100, height: 100)
    }
}
