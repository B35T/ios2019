//
//  ImageCell.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
//    let calayer = CALayer()
//    override var isSelected: Bool {
//        didSet {
//            self.calayer.backgroundColor = self.isSelected ? UIColor.white.cgColor  : UIColor.clear.cgColor
//        }
//    }
    
    var thumbnail: UIImage? {
        didSet {
            self.imageview.image = self.thumbnail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        calayer.frame = .init(x: 0, y: frame.height - 1.5, width: frame.width, height: 1.5)
//        self.layer.addSublayer(calayer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.labelTitle.text = nil
        self.thumbnail = nil
    }
}
