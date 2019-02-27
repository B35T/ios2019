//
//  PreviewViewCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class PreviewViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    
    var image:UIImage? {
        didSet {
            self.imageview.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageview.image = nil
    }
}
