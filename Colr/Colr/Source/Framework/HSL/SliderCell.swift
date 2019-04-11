//
//  SliderCell.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class SliderCell: UICollectionViewCell {

    @IBOutlet weak var slider: HSLSlider!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var value:String? = "0.0"{
        didSet {
            self.valueLabel.text = self.value
        }
    }
    var title: String? {
        didSet {
            self.labelTitle.text = self.title
        }
    }
    
    func ResetBtnAddTarget(target:Any?, action:Selector, for event: UIControl.Event) {
        self.resetBtn.addTarget(target, action: action, for: event)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.add()
        self.value = "0.0"
        self.resetBtn.setTitleColor(.white, for: .normal)
        self.resetBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.resetBtn.layer.cornerRadius = 3
        
        self.resetBtn.addTarget(self, action: #selector(resetAction(_:)), for: .touchUpInside)
        self.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
        
    }

    @objc internal func resetAction(_ sender: UIButton) {
        self.value = "0.0"
        self.slider.value = 0.0
    }
    
    @objc internal func sliderAction(_ sender: UISlider) {
        let str = String(format: "%0.2f", sender.value)
        self.value = str
    }
}
