//
//  SliderCell.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol HSLSliderDelegate {
    func HSLSliderValue(title: String?, value:Float)
}

class SliderView: UIView {

    var delegate: HSLSliderDelegate?

    
    @IBOutlet weak var slider: HSLSlider!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var value:Float? = 0.0 {
        didSet {
            self.slider.value = self.value ?? 0.0
            self.valueLabel.text = String(format: "%0.2f", self.value ?? 0.0)
        }
    }
    var title: String? {
        didSet {
            self.labelTitle.text = self.title
            
            switch self.title ?? "" {
            case "Hue": self.slider.minimumValue = -0.5; self.slider.maximumValue = 0.5; self.slider.value = 0
            case "Saturation": self.slider.minimumValue = 0; self.slider.maximumValue = 2; self.slider.value = 1
            case "Lightness": self.slider.minimumValue = 0; self.slider.maximumValue = 2; self.slider.value = 1
            default:
                break
            }
        }
    }
    
    func ResetBtnAddTarget(target:Any?, action:Selector, for event: UIControl.Event) {
        self.resetBtn.addTarget(target, action: action, for: event)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.add()
        self.value = 0.0
        self.resetBtn.setTitleColor(.white, for: .normal)
        self.resetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.resetBtn.layer.cornerRadius = 3
        
        self.resetBtn.addTarget(self, action: #selector(resetAction(_:)), for: .touchUpInside)
        self.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
        
    }

    @objc internal func resetAction(_ sender: UIButton) {
        switch self.title ?? "" {
        case "Hue": self.value = 0.0
        case "Saturation": self.value = 1.0
        case "Lightness": self.value = 1.0
        default:
            break
        }
        
        self.delegate?.HSLSliderValue(title: title, value: self.value ?? 0)
    }
    
    @objc internal func sliderAction(_ sender: UISlider) {
        self.value = sender.value
        self.delegate?.HSLSliderValue(title: title, value: sender.value)
    }
}
