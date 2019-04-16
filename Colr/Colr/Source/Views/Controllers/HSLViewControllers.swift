//
//  HSLController.swift
//  Colr
//
//  Created by chaloemphong on 16/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLViewControllerDelegate {
    func HSLResult(image: UIImage?, model:HSLModel?)
    func HSLViewBack()
}

class HSLViewControllers: UIViewController {
    
    @IBOutlet open weak var background: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hue:HSLSlider!
    @IBOutlet weak var saturation:HSLSlider!
    @IBOutlet weak var lightness:HSLSlider!
    @IBOutlet weak var hueLabel:UILabel!
    @IBOutlet weak var saturationLabel:UILabel!
    @IBOutlet weak var lightnessLabel:UILabel!
    @IBOutlet weak var hueResetBtn:UIButton!
    @IBOutlet weak var saturationResetBtn:UIButton!
    @IBOutlet weak var lightnessResetBtn:UIButton!
    @IBOutlet weak var hueValueLabel: UILabel!
    @IBOutlet weak var saturationValueLabel: UILabel!
    @IBOutlet weak var lightnessValueLabel: UILabel!
    
    let Multi = MultiBandHSV()
    var colorCell:[Int:HSLCell] = [:]
    var value:HSLVector? = HSLVector(hue: 0, saturation: 1, lightness: 1)
    
    var HSLColor:Color.HSLColorSet = .red
    var select = 0
    // for sender
    var HSLModelValue:HSLModel?
    var Engine: ProcessEngine!
    
    var delegate: HSLViewControllerDelegate?
    var prevoid: HSLModel?
    var prevoidimage:UIImage!
    var ciimage: CIImage!
    public var image:UIImage? {
        didSet {
            guard let image = self.image else {return}
            self.prevoidimage = image
            self.ciimage = CIImage(image: image)
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
        let background = UIView(frame: .zero)
        self.background = background
        self.background.frame = .init(x: 0, y: view.h - 400, width: view.w, height: 400)
        self.view.addSubview(self.background)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.w, height: background.h + 50)
        
        self.collectionView.frame = .init(x: 0, y: 5, width: view.w, height: 50)
        self.collectionView.backgroundColor = .clear
        self.background.backgroundColor = .clear
        self.background.addSubview(blurView)
        
        let hueLabel = UILabel(frame: .zero)
        self.hueLabel = hueLabel
        self.hueLabel.frame = .init(x: 20, y: 85, width: 100, height: 20)
        self.hueLabel.text = "Hue"
        self.hueLabel.textColor = .white
        self.hueLabel.font = UIFont.systemFont(ofSize: 12)
        self.background.addSubview(self.hueLabel)
        
        let saturationLabel = UILabel(frame: .zero)
        self.saturationLabel = saturationLabel
        self.saturationLabel.frame = .init(x: 20, y: 165, width: 100, height: 20)
        self.saturationLabel.text = "Saturation"
        self.saturationLabel.textColor = .white
        self.saturationLabel.font = UIFont.systemFont(ofSize: 12)
        self.background.addSubview(self.saturationLabel)
        
        let lightnessLabel = UILabel(frame: .zero)
        self.lightnessLabel = lightnessLabel
        self.lightnessLabel.frame = .init(x: 20, y: 245, width: 100, height: 20)
        self.lightnessLabel.text = "Lightness"
        self.lightnessLabel.textColor = .white
        self.lightnessLabel.font = UIFont.systemFont(ofSize: 12)
        self.background.addSubview(self.lightnessLabel)
        
        let hueResetBtn = UIButton(frame: .zero)
        self.hueResetBtn = hueResetBtn
        self.hueResetBtn.setTitle("Reset", for: .normal)
        self.hueResetBtn.frame = .init(x: view.w - 80, y: 85, width: 60, height: 25)
        self.hueResetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.hueResetBtn.setTitleColor(.white, for: .normal)
        self.hueResetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.hueResetBtn.layer.cornerRadius = 4
        self.hueResetBtn.tag = 0
        self.hueResetBtn.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        self.background.addSubview(self.hueResetBtn)
        
        let saturationResetBtn = UIButton(frame: .zero)
        self.saturationResetBtn = saturationResetBtn
        self.saturationResetBtn.frame = .init(x: view.w - 80, y: 165, width: 60, height: 25)
        self.saturationResetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.saturationResetBtn.setTitleColor(.white, for: .normal)
        self.saturationResetBtn.setTitle("Reset", for: .normal)
        self.saturationResetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.saturationResetBtn.layer.cornerRadius = 4
        self.saturationResetBtn.tag = 1
        self.saturationResetBtn.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        self.background.addSubview(self.saturationResetBtn)
        
        let lightnessResetBtn = UIButton(frame: .zero)
        self.lightnessResetBtn = lightnessResetBtn
        self.lightnessResetBtn.frame = .init(x: view.w - 80, y: 245, width: 60, height: 25)
        self.lightnessResetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.lightnessResetBtn.setTitleColor(.white, for: .normal)
        self.lightnessResetBtn.setTitle("Reset", for: .normal)
        self.lightnessResetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.lightnessResetBtn.layer.cornerRadius = 4
        self.lightnessResetBtn.tag = 2
        self.lightnessResetBtn.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        self.background.addSubview(self.lightnessResetBtn)
        
        let hue = HSLSlider(frame: .zero)
        self.hue = hue
        self.hue.tag = 0
        self.hue.add()
        self.hue.frame = .init(x: 15, y: 120, width: view.w - 30, height: 30)
        self.hue.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.hue.minimumValue = -0.5
        self.hue.maximumValue = 0.5
        self.hue.value = 0
        self.background.addSubview(self.hue)
        
        let saturation = HSLSlider(frame: .zero)
        self.saturation = saturation
        self.saturation.tag = 1
        self.saturation.add()
        self.saturation.frame = .init(x: 15, y: 200, width: view.w - 30, height: 30)
        self.saturation.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.saturation.minimumValue = 0
        self.saturation.maximumValue = 2
        self.saturation.value = 1
        self.background.addSubview(self.saturation)
        
        let lightness = HSLSlider(frame: .zero)
        self.lightness = lightness
        self.lightness.tag = 2
        self.lightness.add()
        self.lightness.frame = .init(x: 15, y: 280, width: view.w - 30, height: 30)
        self.lightness.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.lightness.minimumValue = 0
        self.lightness.maximumValue = 2
        self.lightness.value = 1
        self.background.addSubview(self.lightness)
        
        let hueValueLabel = UILabel()
        self.hueValueLabel = hueValueLabel
        self.hueValueLabel.frame = .init(x: view.w / 2 - 30, y: 80, width: 60, height: 20)
        self.hueValueLabel.textColor = .white
        self.hueValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.hueValueLabel.textAlignment = .center
        self.background.addSubview(self.hueValueLabel)
        
        let saturationValueLabel = UILabel()
        self.saturationValueLabel = saturationValueLabel
        self.saturationValueLabel.frame = .init(x: view.w / 2 - 30, y: 165, width: 60, height: 20)
        self.saturationValueLabel.textColor = .white
        self.saturationValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.saturationValueLabel.textAlignment = .center
        self.background.addSubview(self.saturationValueLabel)
        
        let lightnessValueLabel = UILabel()
        self.lightnessValueLabel = lightnessValueLabel
        self.lightnessValueLabel.frame = .init(x: view.w / 2 - 30, y: 245, width: 60, height: 20)
        self.lightnessValueLabel.textColor = .white
        self.lightnessValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.lightnessValueLabel.textAlignment = .center
        self.background.addSubview(self.lightnessValueLabel)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.background.addSubview(self.collectionView)
        
        Multi.inputImage = ciimage
        self.update()
        self.prevoid = HSLModelValue
        self.getValue()
    }
    

    @objc internal func dismissAction() {
        self.delegate?.HSLResult(image: prevoidimage!, model: prevoid)
        self.delegate?.HSLViewBack()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func doneAction() {
        self.delegate?.HSLViewBack()
        self.dismiss(animated: true, completion: nil)
    }
}

extension HSLViewControllers: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevoid = self.select
        self.colorCell[prevoid]?.isSelected = false
        
        self.select = indexPath.item
        self.colorCell[self.select]?.isSelected = true
        
        self.HSLColor = Color.HSLColorSet.init(rawValue: indexPath.item) ?? .red
        self.getValue()
    }
}
extension HSLViewControllers {
    @objc internal func button(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.hue.value = 0.0
            self.hueValueLabel.text = "0.0"
            self.value?.hue = 0.0
        case 1:
            self.saturation.value = 1.0
            self.saturationValueLabel.text = "1.00"
            self.value?.saturation = 1.0
        case 2:
            self.lightness.value = 1.0
            self.lightnessValueLabel.text = "1.00"
            self.value?.lightness = 1.0
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
    
    @objc internal func slider(sender:UISlider) {
        switch sender.tag {
        case 0: self.value?.hue = CGFloat(sender.value);self.hueValueLabel.text = String(format: "%0.2f", sender.value)
        case 1: self.value?.saturation = CGFloat(sender.value);self.saturationValueLabel.text = String(format: "%0.2f", sender.value)
        case 2: self.value?.lightness = CGFloat(sender.value);self.lightnessValueLabel.text = String(format: "%0.2f", sender.value)
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
        
        
        self.hue.value = Float(value?.hue ?? 0)
        self.saturation.value = Float(value?.saturation ?? 1)
        self.lightness.value = Float(value?.lightness ?? 1)
        
        self.hueValueLabel.text = String(format: "%0.2f", self.hue.value)
        self.saturationValueLabel.text = String(format: "%0.2f", self.saturation.value)
        self.lightnessValueLabel.text = String(format: "%0.2f", self.lightness.value)
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


extension HSLViewControllers: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Color().HSLColors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorHSLCell", for: indexPath) as! HSLCell
        
        cell.colorView.backgroundColor = Color().HSLColors[indexPath.item]
        cell.colorView.layer.cornerRadius = 22
        self.colorCell.updateValue(cell, forKey: indexPath.item)
        if indexPath.item == select {
            cell.isSelected = true
        }
        
        return cell
    }
}


extension HSLViewControllers: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 25)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 10)
    }
}
