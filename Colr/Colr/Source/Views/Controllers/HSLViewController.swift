//
//  HSLViewController.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLViewControllerDelegate {
    func HSLViewBack()
}

class HSLViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    
    public var delegate: HSLViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        
        self.collectionView.register(UINib(nibName: "HSLColorCell", bundle: nil), forCellWithReuseIdentifier: "HSLColorCell")
        self.collectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = self.background.frame.size
        self.background.backgroundColor = .clear
        self.background.addSubview(blurView)
        
        self.collectionView.backgroundColor = .clear
        self.background.addSubview(self.collectionView)
        
        let closeBtn = CloseButtonIcon()
        closeBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: view.h - 60))
        
        let chooseBtn = ChooseButtonIcon()
        chooseBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        chooseBtn.add(view: view, .init(x: view.w - 60, y: view.h - 60))
        
        let labelTitle = PresetLabel()
        labelTitle.add(view: view)
        labelTitle.setup()
        labelTitle.frame.origin.y = view.h - 55
        labelTitle.center.x = view.center.x
        labelTitle.text = "HSL"
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func dismissAction() {
        self.delegate?.HSLViewBack()
        self.dismiss(animated: true, completion: nil)
    }
}


extension HSLViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HSLColorCell", for: indexPath) as! HSLColorCell
            return cell
        case 1,2,3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            let title = ["","Hue", "Saturation", "Light"]
            cell.title = title[indexPath.section]
            return cell
        default:
            fatalError()
        }
        
    }
}


extension HSLViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.w, height: 50)
        default:
            return CGSize(width: view.w, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 5, height: 25)
        default:
            return CGSize(width: 10, height: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 5, height: 10)
        default:
            return CGSize(width: 10, height: 10)
        }
    }
}
