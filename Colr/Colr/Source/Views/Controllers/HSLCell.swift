//
//  HSLCell.swift
//  Colr
//
//  Created by chaloemphong on 16/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class HSLCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override var isSelected: Bool {
        didSet {
            self.colorView.layer.borderColor = UIColor.white.cgColor
            self.colorView.layer.borderWidth = self.isSelected ? 2 : 0
        }
    }
}
