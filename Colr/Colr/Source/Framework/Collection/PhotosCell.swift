//
//  PhotosCell.swift
//  Colr
//
//  Created by chaloemphong on 20/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageview.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageview.image = nil
        
    }
}
