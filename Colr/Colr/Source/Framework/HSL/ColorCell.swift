//
//  ColorCell.swift
//  Colr
//
//  Created by chaloemphong on 11/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    
    override var isSelected: Bool {
        didSet {
            self.view.layer.borderColor = UIColor.white.cgColor
            self.view.layer.borderWidth = self.isSelected ? 2 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
