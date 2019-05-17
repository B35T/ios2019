//
//  StraightenCell.swift
//  Disaya
//
//  Created by chaloemphong on 17/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

protocol StraightenCellDelegate {
    func StraightenAction(value:Float)
}

class StraightenCell: UICollectionViewCell {

    var delegate: StraightenCellDelegate?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var reset: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slider.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        self.reset.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        self.slider.addTarget(self, action: #selector(sliderAction(_:)), for: .valueChanged)
    }

    @objc internal func resetAction() {
        self.slider.value = 0
        self.delegate?.StraightenAction(value: 0)
    }
    
    @objc internal func sliderAction(_ sender: UISlider) {
        self.delegate?.StraightenAction(value: sender.value)
    }
}
