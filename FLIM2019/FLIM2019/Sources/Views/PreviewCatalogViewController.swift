//
//  PreviewCatalogViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 15/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol PreviewCatalogViewControllerDelegate {
    func PreviewBackAction()
    func PreviewChooseAction(item:String?)
}

class PreviewCatalogViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var chooseBtn: UIButton!


    var item:String = "" {
        didSet {
            self.collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
            self.collectionView.reloadData()
        }
    }
//    var rect: CGRect = .zero {
//        didSet {
//            print(self.rect)
//        }
//    }
    
    var model = PresetModels()
    var delegate: PreviewCatalogViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let d = UIScreen.main.bounds
        
        self.view.frame = .init(x: 0, y: 0, width: d.width, height: d.height)
        self.collectionView.frame = .init(x: 0, y: 0, width: d.width, height: d.height)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let backBtn = UIButton()
        self.backBtn = backBtn
        self.backBtn.frame = .init(x: -10, y: 30, width: 76, height: 35)
        self.backBtn.setBackgroundImage(UIImage(named: "back.png"), for: .normal)
        self.backBtn.layer.cornerRadius = 15
        self.backBtn.clipsToBounds = true
        
        self.backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view.addSubview(self.backBtn)
        
        if UIScreen.main.bounds.height < 800 {
            self.backBtn.layer.compositingFilter = "screenBlendMode"
        }
        
        let chooseBtn = UIButton()
        self.chooseBtn = chooseBtn
        self.chooseBtn.frame = .init(x: 10, y: d.height - 70, width: d.width - 20, height: 55)
        self.chooseBtn.setTitle("CHOOSE", for: .normal)
        self.chooseBtn.setTitleColor(.white, for: .normal)
        self.chooseBtn.backgroundColor = blue
        self.chooseBtn.layer.cornerRadius = 4
        self.chooseBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        self.chooseBtn.clipsToBounds = true
        self.chooseBtn.addTarget(self, action: #selector(self.chooseAction), for: .touchUpInside)
        self.view.addSubview(self.chooseBtn)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func chooseAction() {
        self.delegate?.PreviewChooseAction(item: self.item)
    }
    
    @objc internal func back() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = 0
            self.view.alpha = 0
        }
        self.delegate?.PreviewBackAction()
    }
}

extension PreviewCatalogViewController: UICollectionViewDelegate {
    
}

extension PreviewCatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.items[self.item] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! previewCatalogCell
        
        cell.imageview.image = UIImage(named: "\(self.item)_\(indexPath.item).jpg")
        cell.imageview.contentMode = .scaleAspectFill
        cell.imageview.clipsToBounds = true
        
        return cell
    }
}

extension PreviewCatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: 100, height: 100)
    }
}
