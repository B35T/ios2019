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
    
    private var textColor = UIColor()
    
    enum select {
        case none
        case line
        case color
        case highlight
    }
    
    let select:CALayer = CALayer()
    override var isSelected: Bool {
        didSet {
            switch self.useIsSelect {
            case .line:
                if self.isSelected {
                    self.imageview.alpha = 1
                    self.layer.addSublayer(self.select)
                } else {
                    self.imageview.alpha = 0.5
                    self.select.removeFromSuperlayer()
                }
            case .color:
                if self.isSelected {
                    textLabel.backgroundColor = UIColor.init(red: 255/255, green: 196/255, blue: 20/255, alpha: 1)
                    textLabel.textColor = .white
                } else {
                    textLabel.backgroundColor = .white
                    textLabel.textColor = self.textColor
                }
            case .highlight:
                if self.isSelected {
                    self.imageview.alpha = 1
                } else {
                    self.imageview.alpha = 0.5
                }
            default:
                break
            }
        }
    }
    
    var useIsSelect:select = select.none {
        didSet {
            switch self.useIsSelect {
            case .line:
                self.select.frame = .init(x: 0, y: frame.height - 5, width: frame.width, height: 2)
                self.select.backgroundColor = UIColor.white.cgColor
                self.select.cornerRadius = 1
            default:
                break
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel.text = nil
        self.backgroundColor = .clear
    }
    
    func addText(str:String = "Text", textColor:UIColor = UIColor.init(red: 255/255, green: 196/255, blue: 20/255, alpha: 1), bgColor: UIColor = .white) {
        self.textColor = textColor
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
