//
//  PhotoPreviewCell.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class PhotoPreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageview.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageview.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.image = nil
    }

}
