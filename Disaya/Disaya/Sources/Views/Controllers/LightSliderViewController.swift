//
//  LightSliderViewController.swift
//  Disaya
//
//  Created by chaloemphong on 25/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

enum sliderType: Int {
    case A = 0
    case B
}

protocol LightSliderDelegate {
    func LightSliderTypeA(tag:Int, A:Float?, tool:tool)
    func LightSliderTypeB(tag:Int, A:Float?, B:Float?, tool:tool)
    func LightSliderClose()
}

class LightSliderViewController: UIViewController {

    @IBOutlet weak var sliderA: UISlider!
    @IBOutlet weak var sliderB: UISlider!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var titles:UILabel!
    @IBOutlet weak var background: UIView!
 
    var type:sliderType = .A
    var selectedTool:IndexPath?
    var delegate: LightSliderDelegate?
 
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .clear
 
    }
    
    var values:(Float, Float) = (0,0)
    var oldA:Float = 0
    var oldB:(Float, Float) = (0,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIView()
        self.background = background
        self.background.backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame.size = .init(width: view.frame.width, height: 200)
        self.background.addSubview(blurView)
        
        if self.type == .A {
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
            self.background.frame = .init(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200)
            let sliderA = UISlider()
            self.sliderA = sliderA
            self.sliderB.tag = 0
            self.sliderA.frame = .init(x: 10, y: 10, width: view.frame.width - 20, height: 30)
            
            let sliderB = UISlider()
            self.sliderB = sliderB
            self.sliderB.tag = 1
            self.sliderB.frame = .init(x: 10, y: 50, width: view.frame.width - 20, height: 30)
            
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
        
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc internal func sliderAction(_ sender: UISlider) {
        if self.type == .A {
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
            let t = tool(rawValue: selectedTool!.item)!
            if sender.tag == 0 {
                self.values.0 = sender.value
                self.value.text = String(format: "%0.1f", values.0)
                self.delegate?.LightSliderTypeB(tag: 1, A: self.values.0, B: self.values.1, tool: t)
            } else {
                self.values.1 = sender.value
                self.value.text = String(format: "%0.1f", values.1)
                self.delegate?.LightSliderTypeB(tag: 1, A: self.values.0, B: self.values.1, tool: t)
            }
            
        }
        
    }

    @objc internal func closeAction() {
        if self.type == .A {
            let t = tool(rawValue: selectedTool!.item)!
            self.delegate?.LightSliderTypeA(tag: 0, A: self.oldA, tool: t)
        } else {
            let t = tool(rawValue: selectedTool!.item)!
            self.delegate?.LightSliderTypeB(tag: 1, A: self.values.0, B: self.values.1, tool: t)
            
        }
        
        self.delegate?.LightSliderClose()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func chooseAction() {
        self.delegate?.LightSliderClose()
        self.dismiss(animated: true, completion: nil)
    }
}
