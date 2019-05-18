//
//  HSLViewController.swift
//  Disaya
//
//  Created by chaloemphong on 18/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLViewControllerDelegate {
    func HSLResult(model:DisayaProfile?)
    func HSLShow(action:Bool)
}

class HSLViewController: UIViewController {
    
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
    
    
    var delegate: HSLViewControllerDelegate?
    var color = Color()
    var colorCell:[Int:HSLCell] = [:]
    var value:HSLVector? = HSLVector(hue: 0, saturation: 1, lightness: 1)
    var HSLColor:Color.HSLColorSet = .red
    var profile = DisayaProfile.shared
    var select = 0
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
        let background = UIView(frame: .zero)
        self.background = background
        self.background.frame = .init(x: 0, y: view.frame.height - 370, width: view.frame.width, height: 370)
        self.view.addSubview(self.background)
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.frame.width, height: background.frame.height + 50)
    
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
        self.hueResetBtn.frame = .init(x: view.frame.width - 80, y: 85, width: 60, height: 25)
        self.hueResetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.hueResetBtn.setTitleColor(.white, for: .normal)
        self.hueResetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.hueResetBtn.layer.cornerRadius = 4
        self.hueResetBtn.tag = 0
        self.hueResetBtn.addTarget(self, action: #selector(button(_:)), for: .touchUpInside)
        self.background.addSubview(self.hueResetBtn)
        
        let saturationResetBtn = UIButton(frame: .zero)
        self.saturationResetBtn = saturationResetBtn
        self.saturationResetBtn.frame = .init(x: view.frame.width - 80, y: 165, width: 60, height: 25)
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
        self.lightnessResetBtn.frame = .init(x: view.frame.width - 80, y: 245, width: 60, height: 25)
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
        self.hue.frame = .init(x: 15, y: 120, width: view.frame.width - 30, height: 30)
        self.hue.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.hue.minimumValue = -0.5
        self.hue.maximumValue = 0.5
        self.hue.value = 0
        self.background.addSubview(self.hue)
        
        let saturation = HSLSlider(frame: .zero)
        self.saturation = saturation
        self.saturation.tag = 1
        self.saturation.add()
        self.saturation.frame = .init(x: 15, y: 200, width: view.frame.width - 30, height: 30)
        self.saturation.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.saturation.minimumValue = 0
        self.saturation.maximumValue = 2
        self.saturation.value = 1
        self.background.addSubview(self.saturation)
        
        let lightness = HSLSlider(frame: .zero)
        self.lightness = lightness
        self.lightness.tag = 2
        self.lightness.add()
        self.lightness.frame = .init(x: 15, y: 280, width: view.frame.width - 30, height: 30)
        self.lightness.addTarget(self, action: #selector(slider), for: .valueChanged)
        self.lightness.minimumValue = 0
        self.lightness.maximumValue = 2
        self.lightness.value = 1
        self.background.addSubview(self.lightness)
        
        let hueValueLabel = UILabel()
        self.hueValueLabel = hueValueLabel
        self.hueValueLabel.frame = .init(x: view.frame.width / 2 - 30, y: 80, width: 60, height: 20)
        self.hueValueLabel.textColor = .white
        self.hueValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.hueValueLabel.textAlignment = .center
        self.background.addSubview(self.hueValueLabel)
        
        let saturationValueLabel = UILabel()
        self.saturationValueLabel = saturationValueLabel
        self.saturationValueLabel.frame = .init(x: view.frame.width / 2 - 30, y: 165, width: 60, height: 20)
        self.saturationValueLabel.textColor = .white
        self.saturationValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.saturationValueLabel.textAlignment = .center
        self.background.addSubview(self.saturationValueLabel)
        
        let lightnessValueLabel = UILabel()
        self.lightnessValueLabel = lightnessValueLabel
        self.lightnessValueLabel.frame = .init(x: view.frame.width / 2 - 30, y: 245, width: 60, height: 20)
        self.lightnessValueLabel.textColor = .white
        self.lightnessValueLabel.font = UIFont.systemFont(ofSize: 12)
        self.lightnessValueLabel.textAlignment = .center
        self.background.addSubview(self.lightnessValueLabel)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.frame = .init(x: 0, y: background.frame.origin.y + 10, width: view.frame.width, height: 50)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let close = UIButton(frame: .init(x: 10, y: view.frame.height - 40, width: 35, height: 35))
        close.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        close.layer.compositingFilter = "screenBlendMode"
        self.view.insertSubview(close, at: 6)
        
        self.getValue()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func closeAction() {
        self.delegate?.HSLShow(action: false)
        self.dismiss(animated: true, completion: nil)
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
            profile.red = self.value
        case .aque:
            profile.aqua = self.value
        case .blue:
            profile.blue = self.value
        case .green:
            profile.green = self.value
        case .magenta:
            profile.magenta = self.value
        case .orange:
            profile.orange = self.value
        case .purple:
            profile.purple = self.value
        case .yellow:
            profile.yellow = self.value
        }
        
    }
    
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
            profile.red = self.value
        case .aque:
            profile.aqua = self.value
        case .blue:
            profile.blue = self.value
        case .green:
            profile.green = self.value
        case .magenta:
            profile.magenta = self.value
        case .orange:
            profile.orange = self.value
        case .purple:
            profile.purple = self.value
        case .yellow:
            profile.yellow = self.value
        }
    }
    
    func getValue() {
        switch HSLColor {
        case .red: self.value = profile.red ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .aque: self.value = profile.aqua ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .blue: self.value = profile.blue ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .green: self.value = profile.green ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .magenta: self.value = profile.magenta ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .orange: self.value = profile.orange ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .purple: self.value = profile.purple ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        case .yellow: self.value = profile.yellow ?? HSLVector(hue: 0, saturation: 1, lightness: 1)
        }
        
        self.hue.value = Float(value?.hue ?? 0)
        self.saturation.value = Float(value?.saturation ?? 1)
        self.lightness.value = Float(value?.lightness ?? 1)
        
        self.hueValueLabel.text = String(format: "%0.2f", self.hue.value)
        self.saturationValueLabel.text = String(format: "%0.2f", self.saturation.value)
        self.lightnessValueLabel.text = String(format: "%0.2f", self.lightness.value)
    }
}

extension HSLViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pre = self.select
        self.colorCell[pre]?.isSelected = false
        
        self.select = indexPath.item
        self.colorCell[self.select]?.isSelected = true
        
        self.HSLColor = Color.HSLColorSet.init(rawValue: indexPath.item) ?? .red
        self.getValue()
    }
    
}
