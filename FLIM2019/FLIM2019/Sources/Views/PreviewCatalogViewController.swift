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


    var item:String?
    var rect: CGRect = .zero {
        didSet {
            print(self.rect)
        }
    }
    
    var delegate: PreviewCatalogViewControllerDelegate?
    
    let url = URL(string: "https://images.unsplash.com/photo-1563093027-4f8d7eccd063?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80")
    
    var preimage:[UIImage?] = [nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let backBtn = UIButton()
        self.backBtn = backBtn
        self.backBtn.frame = .init(x: 5, y: 30, width: 70, height: 30)
        self.backBtn.setBackgroundImage(UIImage(named: "back.png"), for: .normal)
        self.backBtn.layer.cornerRadius = 15
        self.backBtn.clipsToBounds = true
        self.backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view.addSubview(self.backBtn)
        
        let chooseBtn = UIButton()
        self.chooseBtn = chooseBtn
        self.chooseBtn.frame = .init(x: 10, y: view.frame.height - 65, width: view.frame.width - 20, height: 55)
        self.chooseBtn.setTitle("CHOOSE", for: .normal)
        self.chooseBtn.setTitleColor(.white, for: .normal)
        self.chooseBtn.backgroundColor = blue
        self.chooseBtn.layer.cornerRadius = 4
        self.chooseBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        self.chooseBtn.clipsToBounds = true
        self.chooseBtn.addTarget(self, action: #selector(self.chooseAction), for: .touchUpInside)
        self.view.addSubview(self.chooseBtn)
        
        let img = UIImage(data: try! Data(contentsOf: self.url!))
        self.preimage = [img]
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! previewCatalogCell
        
        cell.imageview.image = self.preimage.first!
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
}
