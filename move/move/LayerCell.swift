//
//  LayerCell.swift
//  move
//
//  Created by chaloemphong on 6/3/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class LayerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var thumbnail: UIImage? {
        didSet {
            self.imageView.image = thumbnail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemLabel.text = nil
        self.imageView.image = nil
    }
}
