//
//  HSLViewController.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLViewControllerDelegate {
    func HSLResult(image: UIImage?)
    func HSLViewBack()
}

class HSLViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    
    public var delegate: HSLViewControllerDelegate?
    
    public var image:UIImage? {
        didSet {
            guard let image = self.image else {return}
            print("add image")
            self.ciimage = CIImage(image: image)
        }
    }
    fileprivate var ciimage:CIImage?
    
    fileprivate var HSLColor = Color.HSLColorSet.red
    
    fileprivate var colorCell:[Int:HSLColorCell] = [:]
    fileprivate var sliderCell:[Int:SliderCell] = [:]
    
    let HSV = HSLEngine.shared.HSV
    fileprivate var value:HSLVector? = HSLVector(hue: 0, saturation: 1, lightness: 1)
    fileprivate var HSLModelValue:HSLModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.backgroundColor = .clear
        self.background.frame = .init(x: 0, y: view.h - 400, width: view.w, height: 400)
        
        self.collectionView.register(UINib(nibName: "HSLColorCell", bundle: nil), forCellWithReuseIdentifier: "HSLColorCell")
        self.collectionView.register(UINib(nibName: "SliderCell", bundle: nil), forCellWithReuseIdentifier: "SliderCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.w, height: background.h + 50)
        
        self.background.backgroundColor = .clear
        self.background.addSubview(blurView)
        
        self.collectionView.backgroundColor = .clear
        self.background.addSubview(self.collectionView)
        
        let closeBtn = CloseButtonIcon()
        closeBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        closeBtn.add(view: view, .init(x: 10, y: view.h - 60))
        
        let doneBtn = ChooseButtonIcon()
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneBtn.add(view: view, .init(x: view.w - 60, y: view.h - 60))
        
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
    
    @objc internal func doneAction() {
        self.delegate?.HSLViewBack()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func dismissAction() {
        self.delegate?.HSLViewBack()
        self.dismiss(animated: true, completion: nil)
    }
}

extension HSLViewController: HSLSliderDelegate , HSLColorCellDelegate {
    func HSLColorSelect(HSL: Any?, index: Int) {
        self.HSLColor = Color.HSLColorSet.init(rawValue: index) ?? .red
        
        self.getValue()
    }
    
    
    func HSLSliderValue(title: String?, value: Float) {
        guard let ciimage = ciimage else {return}
        HSV.inputImage = ciimage
        switch title ?? "" {
        case "Hue": self.value?.hue = CGFloat(value)
        case "Saturation": self.value?.saturation = CGFloat(value)
        case "Lightness": self.value?.lightness = CGFloat(value)
        default:
            break
        }
        
        switch HSLColor {
        case .red: HSV.inputRedShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .aque: HSV.inputAquaShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .blue: HSV.inputBlueShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .green: HSV.inputGreenShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .magenta: HSV.inputMagentaShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .orange: HSV.inputOrangeShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .purple: HSV.inputPurpleShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .yellow: HSV.inputYellowShift = self.value?.vector ?? CIVector(x: 0, y: 1, z: 1)
        }
        
        guard let result = HSV.outputImage else {print("no image");return}
        self.delegate?.HSLResult(image: UIImage(ciImage: result))
    }
    
    func getValue() {
        switch HSLColor {
        case .red: self.value = HSLEngine.shared.red ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .aque: self.value = HSLEngine.shared.aqua ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .blue: self.value = HSLEngine.shared.blue ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .green: self.value = HSLEngine.shared.green ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .magenta: self.value = HSLEngine.shared.magenta ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .orange: self.value = HSLEngine.shared.orange ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .purple: self.value = HSLEngine.shared.purple ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .yellow: self.value = HSLEngine.shared.yellow ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        }
        
        self.sliderCell[1]?.value = Float(value?.hue ?? 0)
        self.sliderCell[2]?.value = Float(value?.saturation ?? 1)
        self.sliderCell[3]?.value = Float(value?.lightness ?? 1)
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
            cell.delegate = self
            self.colorCell.updateValue(cell, forKey: indexPath.item)
            return cell
        case 1,2,3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
            cell.delegate = self
            let title = ["","Hue", "Saturation", "Lightness"]
            cell.title = title[indexPath.section]
            self.sliderCell.updateValue(cell, forKey: indexPath.section)
            
            self.getValue()
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
