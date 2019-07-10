//
//  LoadViewController.swift
//  FLIM2019
//
//  Created by chaloemphong on 5/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class CatalogViewController: CameraViewModels {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.frame = .init(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.back))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension CatalogViewController: UICollectionViewDelegate {
    
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preview", for: indexPath) as! ImageCell
        cell.imageview.contentMode = .scaleAspectFill
        cell.imageview.image = UIImage(named: "IMG_5078.jpg")
        return cell
    }
    
    
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return .init(width: w, height: w)
    }
}
