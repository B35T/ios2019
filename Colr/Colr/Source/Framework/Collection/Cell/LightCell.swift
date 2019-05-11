//
//  LightCell.swift
//  Colr
//
//  Created by chaloemphong on 14/4/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class LightCell: UICollectionViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titles: String? {
        didSet {
            self.titleLabel.text = self.titles
        }
    }
    
    var value: Float? {
        didSet {
            let f = "%0.0f"
            if self.value! > 100 {
                let str = String(format: f, self.value!)
                self.valueLabel.text = str
            } else {
                let str = String(format: f, self.value! * 100)
                self.valueLabel.text = str
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        self.layer.cornerRadius = 4
    }

}
