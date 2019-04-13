//
//  HSLViewController.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLViewControllerDelegate {
    func HSLResult(image: UIImage?, model:HSLModel?)
    func HSLViewBack()
}

class HSLViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var background: UIView!
    
    let Multi = MultiBandHSV()
    
    fileprivate var ciimage:CIImage?
    fileprivate var HSLColor = Color.HSLColorSet.red
    fileprivate var colorCell:[Int:HSLColorCell] = [:]
    fileprivate var sliderCell:[Int:SliderCell] = [:]
    fileprivate var prevoid: HSLModel?
    fileprivate var value:HSLVector? = HSLVector(hue: 0, saturation: 1, lightness: 1)
    
    
    public var delegate: HSLViewControllerDelegate?
    
    // for sender
    var HSLModelValue:HSLModel?
    var Engine: ProcessEngine!
    var prevoidImg: UIImage?
    
    public var image:UIImage? {
        didSet {
            guard let image = self.image else {return}
            print("add image")
            self.ciimage = CIImage(image: image)
        }
    }
    
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
        
        let chooseBtn = ChooseButtonIcon()
        chooseBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        chooseBtn.add(view: view, .init(x: view.w - 60, y: view.h - 60))
        
        let labelTitle = PresetLabel()
        labelTitle.add(view: view)
        labelTitle.setup()
        labelTitle.frame.origin.y = view.h - 55
        labelTitle.center.x = view.center.x
        labelTitle.text = "HSL"
        
        Multi.inputImage = ciimage
        self.update()
        self.prevoid = HSLModelValue
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @objc internal func dismissAction() {
        self.delegate?.HSLViewBack()
        self.delegate?.HSLResult(image: prevoidImg, model: prevoid)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func doneAction() {
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
        switch title ?? "" {
        case "Hue": self.value?.hue = CGFloat(value)
        case "Saturation": self.value?.saturation = CGFloat(value)
        case "Lightness": self.value?.lightness = CGFloat(value)
        default:
            break
        }
        
        switch HSLColor {
        case .red:
            self.HSLModelValue?.red = self.value
            Multi.inputRedShift = self.HSLModelValue?.red?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .aque:
            self.HSLModelValue?.aqua = self.value
            Multi.inputAquaShift = self.HSLModelValue?.aqua?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .blue:
            self.HSLModelValue?.blue = self.value
            Multi.inputBlueShift = self.HSLModelValue?.blue?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .green:
            self.HSLModelValue?.green = self.value
            Multi.inputGreenShift = self.HSLModelValue?.green?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .magenta:
            self.HSLModelValue?.magenta = self.value
            Multi.inputMagentaShift = self.HSLModelValue?.magenta?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .orange:
            self.HSLModelValue?.orange = self.value
            Multi.inputOrangeShift = self.HSLModelValue?.orange?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .purple:
            self.HSLModelValue?.purple = self.value
            Multi.inputPurpleShift = self.HSLModelValue?.purple?.vector ?? CIVector(x: 0, y: 1, z: 1)
        case .yellow:
            self.HSLModelValue?.yellow = self.value
            Multi.inputYellowShift = self.HSLModelValue?.yellow?.vector ?? CIVector(x: 0, y: 1, z: 1)
        }
        
        guard let output = Multi.outputImage else {print("no output");return}
        self.delegate?.HSLResult(image: UIImage(ciImage: output), model: HSLModelValue)
    }
    
    func getValue() {
        switch HSLColor {
        case .red: self.value = HSLModelValue?.red ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .aque: self.value = HSLModelValue?.aqua ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .blue: self.value = HSLModelValue?.blue ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .green: self.value = HSLModelValue?.green ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .magenta: self.value = HSLModelValue?.magenta ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .orange: self.value = HSLModelValue?.orange ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .purple: self.value = HSLModelValue?.purple ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .yellow: self.value = HSLModelValue?.yellow ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        }
        
        
        self.sliderCell[1]?.value = Float(value?.hue ?? 0)
        self.sliderCell[2]?.value = Float(value?.saturation ?? 1)
        self.sliderCell[3]?.value = Float(value?.lightness ?? 1)
    }
    
    func update() {
        self.Multi.inputRedShift = HSLModelValue?.red?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputAquaShift = HSLModelValue?.aqua?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputBlueShift = HSLModelValue?.blue?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputGreenShift = HSLModelValue?.green?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputMagentaShift = HSLModelValue?.magenta?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputOrangeShift = HSLModelValue?.orange?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputPurpleShift = HSLModelValue?.purple?.vector ?? CIVector(x: 0, y: 1, z: 1)
        self.Multi.inputYellowShift = HSLModelValue?.yellow?.vector ?? CIVector(x: 0, y: 1, z: 1)
        
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
