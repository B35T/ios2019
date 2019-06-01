//
//  LightSliderViewController.swift
//  Disaya
//
//  Created by chaloemphong on 25/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit


protocol LightSliderDelegate {
    func LightSliderTypeA(tag:Int, A:Float?, tool:tool)
    func LightSliderTypeB(A:Float?, B:Float?, option: SliderOption)
    func LightSliderClose()
}

class LightSliderViewController: UIViewController {

    @IBOutlet weak var sliderA: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var titles:UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var valueA:UILabel!
    @IBOutlet weak var valueB:UILabel!
    @IBOutlet weak var titleA:UILabel!
    @IBOutlet weak var titleB:UILabel!

 
    var type:SliderOption = .L
    var selectedTool:IndexPath?
    var delegate: LightSliderDelegate?
 
    
    var values:(Float, Float) = (0,0)
    var oldA:Float = 0
    var oldB:(Float, Float) = (0,0)
    
    var text:(a:String, b:String) = ("Angle", "Radius")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        let background = UIView()
        self.background = background
        self.background.backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.frame.width, height: 250)
        self.background.addSubview(blurView)
        
        if self.type == .L {
            self.background.frame = .init(x: 0, y: view.frame.height - 160, width: view.frame.width, height: 160)
            
            let value = UILabel()
            self.value = value
            self.value.frame = .init(x: view.frame.width / 2 - 35, y: 15, width: 70, height: 30)
            
            self.value.font = UIFont.boldSystemFont(ofSize: 16)
            self.value.textAlignment = .center
            self.value.textColor = .black
            self.value.backgroundColor = yellow
            self.value.layer.cornerRadius = 4
            self.value.clipsToBounds = true
            
            let sliderA = UISlider()
            self.sliderA = sliderA
            self.sliderA.tag = 0
            self.sliderA.frame = .init(x: 10, y: 70, width: view.frame.width - 20, height: 30)
            self.sliderA.minimumTrackTintColor = .white
            
            if let i = selectedTool {
                
                let v = PresetLibrary().toolmin(t: tool(rawValue: i.item)!)
                self.sliderA.maximumValue = v.max
                self.sliderA.minimumValue = v.min
                self.sliderA.value = v.value
                self.oldA = v.value
                switch tool(rawValue: i.item)! {
                case .temperature:
                    self.value.text = String(format: "%0.0f", v.value)
                default:
                    self.value.text = String(format: "%0.1f", v.value)
                }
                
            } else {
                self.sliderA.maximumValue = 1
                self.sliderA.minimumValue = -1
                self.sliderA.value = 0
                self.value.text = "0"
            }
            
            let titles = UILabel()
            self.titles = titles
            self.titles.frame = .init(x: view.frame.width / 2 - 100, y: 120, width: 200, height: 30)
            self.titles.textAlignment = .center
            self.titles.textColor = .white
            self.titles.font = UIFont.boldSystemFont(ofSize: 13)
            self.titles.text = self.title
            self.background.addSubview(self.titles)
            
            self.sliderA.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
            self.background.addSubview(self.value)
            self.background.addSubview(self.sliderA)
            self.view.addSubview(self.background)
        } else {
            self.background.frame = .init(x: 0, y: view.frame.height - 220, width: view.frame.width, height: 220)
            let titleA = UILabel()
            titleA.frame = .init(x: 10, y: 20, width: 60, height: 25)
            titleA.font = UIFont.systemFont(ofSize: 12)
            titleA.textColor = .white
            self.titleA = titleA
            self.background.addSubview(titleA)
            
            let titleB = UILabel()
            titleB.frame = .init(x: 10, y: 95, width: 70, height: 25)
            titleB.font = UIFont.systemFont(ofSize: 12)
            titleB.textColor = .white
            self.titleB = titleB
            self.background.addSubview(self.titleB)
            
            let valueA = UILabel()
            self.valueA = valueA
            self.valueA.frame = .init(x: view.frame.width / 2 - 25, y: 20, width: 50, height: 25)
            self.valueA.font = UIFont.systemFont(ofSize: 12)
            self.valueA.textAlignment = .center
            self.valueA.textColor = .white
            
            let sliderA = UISlider()
            self.sliderA = sliderA
            self.sliderA.tag = 0
            self.sliderA.frame = .init(x: 10, y: 50, width: view.frame.width - 20, height: 30)
            self.sliderA.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
            self.sliderA.minimumTrackTintColor = .white
            
            let valueB = UILabel()
            self.valueB = valueB
            self.valueB.frame = .init(x: view.frame.width / 2 - 25, y: 100, width: 50, height: 25)
            self.valueB.font = UIFont.systemFont(ofSize: 12)
            self.valueB.textAlignment = .center
            self.valueB.textColor = .white
            
            let sliderB = UISlider()
            self.sliderB = sliderB
            self.sliderB.tag = 1
            self.sliderB.frame = .init(x: 10, y: 130, width: view.frame.width - 20, height: 30)
            self.sliderB.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
            self.sliderB.minimumTrackTintColor = .white
            
            let titles = UILabel()
            self.titles = titles
            self.titles.frame = .init(x: view.frame.width / 2 - 100, y: 180, width: 200, height: 30)
            self.titles.textAlignment = .center
            self.titles.textColor = .white
            self.titles.font = UIFont.systemFont(ofSize: 13)
            self.titles.text = self.title
            
            let resetA = UIButton()
            resetA.frame = .init(x: view.frame.width - 80, y: 20, width: 60, height: 25)
            resetA.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            resetA.setTitleColor(.white, for: .normal)
            resetA.setTitle("Reset", for: .normal)
            resetA.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            resetA.layer.cornerRadius = 4
            resetA.tag = 0
            resetA.addTarget(self, action: #selector(buttonResetAction(_:)), for: .touchUpInside)
            self.background.addSubview(resetA)
            
            let resetB = UIButton()
            resetB.frame = .init(x: view.frame.width - 80, y: 100, width: 60, height: 25)
            resetB.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            resetB.setTitleColor(.white, for: .normal)
            resetB.setTitle("Reset", for: .normal)
            resetB.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            resetB.layer.cornerRadius = 4
            resetB.tag = 1
            resetB.addTarget(self, action: #selector(buttonResetAction(_:)), for: .touchUpInside)
            self.background.addSubview(resetB)
            
            self.background.addSubview(self.titles)
            self.background.addSubview(self.valueA)
            self.background.addSubview(self.valueB)
            self.background.addSubview(self.sliderA)
            self.background.addSubview(self.sliderB)
            self.view.addSubview(self.background)
        }

        let close = UIButton(frame: .init(x: 10, y: view.frame.height - 40, width: 35, height: 35))
        close.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        close.layer.compositingFilter = "screenBlendMode"
        self.view.insertSubview(close, at: 6)
        
        let choose = UIButton(frame: .init(x: view.frame.width - 45, y: view.frame.height - 40, width: 35, height: 35))
        choose.setBackgroundImage(UIImage(named: "choose.png"), for: .normal)
        choose.addTarget(self, action: #selector(chooseAction), for: .touchUpInside)
        choose.layer.compositingFilter = "screenBlendMode"
        self.view.insertSubview(choose, at: 6)
        
        
        switch self.type {
        case .CA:
            let a = DisayaProfile.shared.chromatic_angle
            let r = DisayaProfile.shared.chromatic_radius
            self.oldB.0 = Float(a ?? 0)
            self.oldB.1 = Float(r ?? 0)
            self.values.0 = Float(a ?? 0)
            self.values.1 = Float(r ?? 0)
            self.text = ("\(String(format: "%0.1f", a ?? 0))", "\(String(format: "%0.1f", r ?? 0))")
            self.titleA.text = "Angle"
            self.titleB.text = "Radius"
            self.valueA.text = self.text.a
            self.valueB.text = self.text.b
            
            self.sliderA.minimumValue = -1
            self.sliderA.maximumValue = 1
            self.sliderA.value = self.values.0
            
            self.sliderB.minimumValue = -15
            self.sliderB.maximumValue = 15
            self.sliderB.value = self.values.1
        case .TA:
            let f = DisayaProfile.shared.transverse_falloff
            let b = DisayaProfile.shared.transverse_blur
            self.oldB.0 = Float(f ?? 0)
            self.oldB.1 = Float(b ?? 0)
            self.values.0 = Float(f ?? 0)
            self.values.1 = Float(b ?? 0)
            self.text = ("\(String(format: "%0.1f", f ?? 0))", "\(String(format: "%0.1f", b ?? 0))")
            self.titleA.text = "Falloff"
            self.titleB.text = "Blur"
            self.valueA.text = self.text.a
            self.valueB.text = self.text.b
            
            self.sliderA.minimumValue = -1
            self.sliderA.maximumValue = 1
            self.sliderA.value = self.values.0
            
            self.sliderB.minimumValue = -10
            self.sliderB.maximumValue = 10
            self.sliderB.value = self.values.1
        default:
            break
        }
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func sliderAction(_ sender: UISlider) {
        if self.type == .L {
            let t = tool(rawValue: selectedTool!.item)!
            switch t {
            case .temperature:
                self.value.text = String(format: "%0.0f", sender.value)
            default:
                self.value.text = String(format: "%0.1f", sender.value)
            }
            DisayaProfile.shared.updateTools(t: t, value: CGFloat(sender.value))
            self.delegate?.LightSliderTypeA(tag: 0, A: sender.value, tool: t)
        } else {
            if sender.tag == 0 {
                self.values.0 = sender.value
            } else {
                self.values.1 = sender.value
            }
            
            if self.type == .CA {
                self.text = ("\(String(format: "%0.1f", self.values.0))", "\(String(format: "%0.1f", self.values.1))")
            } else if self.type == .TA {
                self.text = ("\(String(format: "%0.1f", self.values.0))", "\(String(format: "%0.1f", self.values.1))")
            }
            
            self.valueA.text = self.text.a
            self.valueB.text = self.text.b
            self.delegate?.LightSliderTypeB(A: self.values.0, B: self.values.1, option: self.type)
        }
        
    }

    @objc internal func closeAction() {
        if self.type == .L {
            let t = tool(rawValue: selectedTool!.item)!
            self.delegate?.LightSliderTypeA(tag: 0, A: self.oldA, tool: t)
        } else {
           
            self.delegate?.LightSliderTypeB(A: self.oldB.0, B: self.oldB.1, option: self.type)
            
        }
        
        self.delegate?.LightSliderClose()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func chooseAction() {
        self.delegate?.LightSliderClose()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func buttonResetAction(_ sender:UIButton) {
        switch self.type {
        case .CA:
            if sender.tag == 0 {
                self.values.0 = 0
                self.sliderA.value = 0
                self.valueA.text = "0.0"
            } else if sender.tag == 1 {
                self.values.1 = 0
                self.sliderB.value = 0
                self.valueB.text = "0.0"
            }
            self.delegate?.LightSliderTypeB(A: self.values.0, B: self.values.1, option: .CA)
        case .TA:
            if sender.tag == 0 {
                self.values.0 = 0
                self.sliderA.value = 0
                self.valueB.text = "0.0"
            } else if sender.tag == 1 {
                self.values.1 = 0
                self.sliderB.value = 0
                self.valueB.text = "0.0"
            }
            self.delegate?.LightSliderTypeB(A: self.values.0, B: self.values.1, option: .TA)
        default:
            break
        }
        
    }
}
