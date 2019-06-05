//
//  PresetPreviewCell.swift
//  Disaya
//
//  Created by chaloemphong on 14/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

class PresetPreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var indexPath: IndexPath = .init(item: 0, section: 0)
    override var isSelected: Bool {
        didSet {
            switch indexPath.section {
            case 0:
                self.labelTitle.backgroundColor = self.isSelected ? black: .white
                self.labelTitle.textColor = self.isSelected ? .white: black
            case 1:
                self.labelTitle.backgroundColor = self.isSelected ? yellow: .white
                self.labelTitle.textColor = self.isSelected ? .white: yellow
            case 2:
                self.labelTitle.backgroundColor = self.isSelected ? red:.white
                self.labelTitle.textColor = self.isSelected ? .white: red
            case 3:
                self.labelTitle.backgroundColor = self.isSelected ? black:.white
                self.labelTitle.textColor = self.isSelected ? .white: black
            case 4:
                self.labelTitle.backgroundColor = self.isSelected ? blue : .white
                self.labelTitle.textColor = self.isSelected ? .white : blue
            case 5:
                self.labelTitle.backgroundColor = self.isSelected ? indigo : .white
                self.labelTitle.textColor = self.isSelected ? .white : indigo
            default:
                break
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageview.image = nil
        self.labelTitle.text = nil
    }
}
