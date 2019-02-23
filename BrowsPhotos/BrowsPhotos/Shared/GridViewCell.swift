//
//  GridViewCell.swift
//  BrowsPhotos
//
//  Created by chaloemphong on 23/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            self.imageView.image = self.thumbnailImage
            self.imageView.clipsToBounds = true
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
