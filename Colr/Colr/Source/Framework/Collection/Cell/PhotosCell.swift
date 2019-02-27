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
    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel.text = nil
        self.backgroundColor = .clear
    }
    
    func addText(str:String = "Text", textColor:UIColor = UIColor.init(red: 255/255, green: 196/255, blue: 20/255, alpha: 1), bgColor: UIColor = .white) {
        self.textLabel.textColor = textColor
        self.textLabel.text = str
        self.textLabel.backgroundColor = bgColor
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
        textLabel.text = nil
        textLabel.backgroundColor = .clear
        
    }
}
