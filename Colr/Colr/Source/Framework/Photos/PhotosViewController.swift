//
//  PhotosViewController.swift
//  Colr
//
//  Created by chaloemphong on 20/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//
import UIKit
import Photos

extension CGFloat {
    public func persen(p:CGFloat) -> CGFloat {
        let c = self / 100 * p
        return c
    }
    
    var x:CGPoint {
        return CGPoint(x: self, y: 0)
    }
    
    var y:CGPoint {
        return CGPoint(x: 0, y: self)
    }
    
    var w:CGSize {
        return CGSize(width: self, height: 0)
    }
    
    var h:CGSize {
        return CGSize(width: 0, height: self)
    }
    
    func minus(i:CGFloat) -> CGFloat {
        return self - i
    }
}

extension UIView {
    func minusSize(_ x:CGFloat = 0.0,_ y:CGFloat = 0.0) -> CGPoint {
        let f = self.frame
        return CGPoint(x: f.width - x, y: f.height - y)
    }
}

class PhotosViewController: UIViewController {
    
    
    @IBOutlet open weak var collection: UICollectionView!
    @IBOutlet open weak var imageview: UIImageView!
    @IBOutlet open weak var closeBtn: CloseButton!
    @IBOutlet open weak var nextBtn: NextButton!
    
    private var imageManager:PHImageManager!
    private var requestOption:PHImageRequestOptions!
    private var fetchOption:PHFetchOptions!
    private var fetchResult:PHFetchResult<PHAsset>!
    
    var c:Int = 0
    
    open override func loadView() {
        super.loadView()
        
        let collec = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collec.translatesAutoresizingMaskIntoConstraints = false
        
        self.collection = collec
        self.collection.frame = self.view.frame
        self.view.addSubview(self.collection)
        
        
        let imageview = UIImageView(frame: .zero)
        self.imageview = imageview
        self.imageview.frame.size.width = self.view.frame.width
        self.imageview.contentMode = .scaleAspectFit
        self.imageview.clipsToBounds = true
        self.view.addSubview(self.imageview)
        
       
        
        let c = CloseButton()
        c.add(view: self.view,.init(x: 25, y: self.view.frame.height.minus(i: 65)))
        c.animatedHidden()
        self.closeBtn = c
        
        let n = NextButton()
        n.add(view: self.view, self.view.minusSize(135, 65))
        n.animatedHidden()
        self.nextBtn = n
        
        print(n)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.imageManager = PHImageManager.default()
        self.requestOption = PHImageRequestOptions()
        self.requestOption.isSynchronous = true
        self.fetchOption = PHFetchOptions()
        
        self.collection.register(UINib(nibName: "HeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        self.collection.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "photos")
        self.collection.delegate = self
        self.collection.dataSource = self
        
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
    }
    
    func animated(action:Bool) {
        let layout = self.collection.collectionViewLayout as! UICollectionViewFlowLayout
        
        UIView.animate(withDuration: 0.3) {
            if action {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height.persen(p: 64.9))
                self.collection.frame.origin = self.view.frame.height.persen(p: 65).y
                self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height.persen(p: 35))
                layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 0)
            } else {
                self.imageview.frame = .init(x: 0, y: 0, width: self.view.frame.width, height: 0)
                self.collection.frame.origin = .zero
                self.collection.frame.size = .init(width: self.view.frame.width, height: self.view.frame.height)
                layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 70)
            }
        }
    }
    
    var count:Int {
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: self.fetchOption)
        self.c = self.fetchResult.count
        return c
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotosCell
        
        let i = (self.c - 1) - indexPath.item
        DispatchQueue.main.async {
            self.imageManager.requestImage(for: self.fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFill, options: self.requestOption, resultHandler: { (image, any) in
                if let img = image {
                    cell.imageview.image = img
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "photos", for: indexPath) as! PhotosCell
        
        let i = (self.c - 1) - indexPath.item
        DispatchQueue.main.async {
            self.imageManager.requestImage(for: self.fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFill, options: self.requestOption, resultHandler: { (image, any) in
                if let img = image {
                    cell.imageview.image = img
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let h = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderReusableView
        h.HeaderLabel.text = "Photos"
        //        h.frame = .init(origin: .zero, size: .init(width: self.view.frame.width, height: 70))
        return h
        
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let i = self.c - 1 - indexPath.item
        self.imageManager.requestImage(for: self.fetchResult.object(at: i), targetSize: CGSize(width: 1000, height: 1000), contentMode: PHImageContentMode.aspectFill, options: self.requestOption) { (image, any) in
            if let img = image {
                self.imageview.image = img
            }
        }
        
        self.closeBtn.animatedHidden(action: false)
        self.nextBtn.animatedHidden(action: false)
        self.animated(action: true)
        self.collection.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.bounds.width / 4 - 1
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: self.view.frame.width, height: 70)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 80)
    }
    
}
