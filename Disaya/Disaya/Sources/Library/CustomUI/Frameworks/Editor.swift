//
//  Editor.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import Photos

open class Editor: UIViewController {
    
    var imagePreview: Preview!
    
    var size: CGSize {
        return .init(width: view.frame.width * UIScreen.main.scale, height: view.frame.width * UIScreen.main.scale)
    }
    
    override open func loadView() {
        super.loadView()
        
        let imagePreview = Preview(frame: .init(x: 0, y: 40, width: view.frame.width, height: view.frame.height / 100 * 69))
        self.imagePreview = imagePreview
        self.view.addSubview(self.imagePreview)
        
        self.view.backgroundColor = .black
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(LongPressHide(_:)))
        long.minimumPressDuration = 0.1
        self.imagePreview.isUserInteractionEnabled = true
        self.imagePreview.addGestureRecognizer(long)
    }
    
    open func maxCal(ago:CGSize, new:CGSize) -> CGFloat {
        return Swift.max(new.width / ago.width, new.height / ago.height)
    }
    
    open func cropMultiply(ago:CGSize, new:CGSize, cropData:CGRect) -> CGRect {
        let c = Swift.max(new.width / ago.width, new.height / ago.height)
        let crop = CGRect(x: cropData.origin.x * c, y: cropData.origin.y * c, width: cropData.width * c, height: cropData.height * c)
        return crop
        
    }
    
    open func nornalRender(ciimage:CIImage?, cropData:(CGRect?, Float?, CGSize?), profile:DisayaProfile) {
        guard let ciimage = ciimage else {return}
        
        if let rect = cropData.0 {
            print(rect)
            if let result = PresetLibrary().toolCreate(ciimage: ciimage, Profile: profile)?.toCGImage {
                let img = UIImage(cgImage: result)
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        } else {
            if let result = PresetLibrary().toolCreate(ciimage: ciimage, Profile: profile)?.toCGImage {
                let img = UIImage(cgImage: result)
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }
        }
    }
    
    open func highQulityRender(_ asset: PHAsset, cropData:(CGRect?, Float?, CGSize?), profile:DisayaProfile) {
        PHImageManager.default().requestImageData(for: asset, options: nil) { (data, str, or, info) in
            guard let ciimage = CIImage(data: data!) else {return}
            let scale = self.maxCal(ago: cropData.2!, new: ciimage.extent.size)
            if cropData.0 != nil && cropData.1 != 0 {
                let filter = CIFilter(name: "CIStraightenFilter")
                filter?.setDefaults()
                filter?.setValue(ciimage, forKey: "inputImage")
                filter?.setValue(cropData.1, forKey: "inputAngle")
                
                let rect = self.cropMultiply(ago: cropData.2!, new: ciimage.extent.size, cropData: cropData.0!)
                let cgimage = filter?.outputImage?.toCGImage?.cropping(to: rect)
                
                if let result = PresetLibrary().toolCreate(ciimage: CIImage(cgImage: cgimage!), Profile: profile, scale: scale)?.toCGImage {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
                
            } else if cropData.1 == 0 && cropData.0 != nil {
                
                let rect = self.cropMultiply(ago: cropData.2!, new: ciimage.extent.size, cropData: cropData.0!)
                let cgimage = ciimage.toCGImage?.cropping(to: rect)
                
                if let result = PresetLibrary().toolCreate(ciimage: CIImage(cgImage: cgimage!), Profile: profile,scale: scale)?.toCGImage {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
            } else {
                
                if let result = PresetLibrary().toolCreate(ciimage: ciimage, Profile: profile, scale: scale)?.toCGImage {
                    let img = UIImage(cgImage: result, scale: 1, orientation: or)
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
            }
        }

    }
 
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func LongPressHide(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .ended: self.imagePreview.topView.alpha = 1
        default:
            self.imagePreview.topView.alpha = 0
        }
    }
}
