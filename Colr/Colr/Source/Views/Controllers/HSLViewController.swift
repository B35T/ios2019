////
////  HSLViewController.swift
////  Colr
////
////  Created by chaloemphong on 11/4/2562 BE.
////  Copyright © 2562 charoemphong. All rights reserved.
////
//
//import UIKit
//import Photos
//
//public protocol HSLViewControllerDelegate {
//    func HSLResult(image: UIImage?, model:HSLModel?)
//    func HSLViewBack()
//}
//
//open class HSLViewController: UIViewController {
//
//    @IBOutlet open weak var background: UIView!
//    
//    let Multi = MultiBandHSV()
//    
//    var ciimage:CIImage?
//    var HSLColor = Color.HSLColorSet.red
//    var colorCell:[Int:HSLColorCell] = [:]
//    var sliderCell:[Int:SliderCell] = [:]
//    var prevoid: HSLModel?
//    var value:HSLVector? = HSLVector(hue: 0, saturation: 1, lightness: 1)
//    
//    
//    var delegate: HSLViewControllerDelegate?
//    
//    // for sender
//    var HSLModelValue:HSLModel?
//    var Engine: ProcessEngine!
//    
//    var prevoidimage:UIImage!
//    
//    public var image:UIImage? {
//        didSet {
//            guard let image = self.image else {return}
//            self.prevoidimage = image
//            self.ciimage = CIImage(image: image)
//        }
//    }
//    
//    override open func loadView() {
//        super.loadView()
//        
//        self.view.backgroundColor = .clear
//        let background = UIView(frame: .zero)
//        self.background = background
//        self.background.frame = .init(x: 0, y: view.h - 400, width: view.w, height: 400)
//        self.view.addSubview(self.background)
//        
//        let blur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame.size = .init(width: view.w, height: background.h + 50)
//        
//        self.background.backgroundColor = .clear
//        self.background.addSubview(blurView)
//        
//        
//    }
//    
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        Multi.inputImage = ciimage
//        self.update()
//        self.prevoid = HSLModelValue
//    }
//
//    
//    override open var prefersStatusBarHidden: Bool {
//        return true
//    }
//}
//
//extension HSLViewController: HSLSliderDelegate , HSLColorCellDelegate {
//    public func HSLColorSelect(HSL: Any?, index: Int) {
//        self.HSLColor = Color.HSLColorSet.init(rawValue: index) ?? .red
//        self.getValue()
//    }
//    
//    
//    public func HSLSliderValue(title: String?, value: Float) {
//        switch title ?? "" {
//        case "Hue": self.value?.hue = CGFloat(value)
//        case "Saturation": self.value?.saturation = CGFloat(value)
//        case "Lightness": self.value?.lightness = CGFloat(value)
//        default:
//            break
//        }
//        
//        switch HSLColor {
//        case .red:
//            self.HSLModelValue?.red = self.value
//            Multi.inputRedShift = self.HSLModelValue?.red?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .aque:
//            self.HSLModelValue?.aqua = self.value
//            Multi.inputAquaShift = self.HSLModelValue?.aqua?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .blue:
//            self.HSLModelValue?.blue = self.value
//            Multi.inputBlueShift = self.HSLModelValue?.blue?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .green:
//            self.HSLModelValue?.green = self.value
//            Multi.inputGreenShift = self.HSLModelValue?.green?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .magenta:
//            self.HSLModelValue?.magenta = self.value
//            Multi.inputMagentaShift = self.HSLModelValue?.magenta?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .orange:
//            self.HSLModelValue?.orange = self.value
//            Multi.inputOrangeShift = self.HSLModelValue?.orange?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .purple:
//            self.HSLModelValue?.purple = self.value
//            Multi.inputPurpleShift = self.HSLModelValue?.purple?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        case .yellow:
//            self.HSLModelValue?.yellow = self.value
//            Multi.inputYellowShift = self.HSLModelValue?.yellow?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        }
//        
//        guard let output = Multi.outputImage else {print("no output");return}
//        self.delegate?.HSLResult(image: UIImage(ciImage: output), model: HSLModelValue)
//    }
//    
//    func getValue() {
//        switch HSLColor {
//        case .red: self.value = HSLModelValue?.red ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .aque: self.value = HSLModelValue?.aqua ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .blue: self.value = HSLModelValue?.blue ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .green: self.value = HSLModelValue?.green ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .magenta: self.value = HSLModelValue?.magenta ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .orange: self.value = HSLModelValue?.orange ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .purple: self.value = HSLModelValue?.purple ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        case .yellow: self.value = HSLModelValue?.yellow ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
//        }
//        
//        
//        self.sliderCell[1]?.value = Float(value?.hue ?? 0)
//        self.sliderCell[2]?.value = Float(value?.saturation ?? 1)
//        self.sliderCell[3]?.value = Float(value?.lightness ?? 1)
//    }
//    
//    func update() {
//        self.Multi.inputRedShift = HSLModelValue?.red?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputAquaShift = HSLModelValue?.aqua?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputBlueShift = HSLModelValue?.blue?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputGreenShift = HSLModelValue?.green?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputMagentaShift = HSLModelValue?.magenta?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputOrangeShift = HSLModelValue?.orange?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputPurpleShift = HSLModelValue?.purple?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        self.Multi.inputYellowShift = HSLModelValue?.yellow?.vector ?? CIVector(x: 0, y: 1, z: 1)
//        
//    }
//
//}
//
