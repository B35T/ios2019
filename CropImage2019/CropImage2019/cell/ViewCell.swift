//
//  ViewCell.swift
//  CropImage2019
//
//  Created by chaloemphong on 31/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class ViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = .yellow
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
}
