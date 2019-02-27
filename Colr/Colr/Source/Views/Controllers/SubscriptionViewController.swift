//
//  SubscriptionViewController.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


class SubscriptionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var subscriptionView: UIView!
    @IBOutlet weak var startSubbtn: UIButton!
    @IBOutlet weak var restoreBtn: UIBarButtonItem!
    
    
    let cells = "PreviewCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionView.frame = .init(x: 0, y: 0, width: view.w, height: view.h)
        self.collectionView.backgroundColor = .black
        
        self.subscriptionView.frame = .init(x: 0, y: view.h.minus(n: 215), width: view.w, height: 215)
        self.startSubbtn.layer.cornerRadius = 6
        self.view.addSubview(self.subscriptionView)
    }

}

extension SubscriptionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cells, for: indexPath) as? PreviewViewCell else {fatalError("init preview collection cell fail")}
        
        cell.image = #imageLiteral(resourceName: "preview")
        return cell
    }
    
    
}


extension SubscriptionViewController: UICollectionViewDelegate {
    
}

extension SubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = CGSize(width: view.w, height: view.w)
        return w
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 220)
    }
}

