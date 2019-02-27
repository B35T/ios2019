//
//  GroupsCell.swift
//  Colr
//
//  Created by chaloemphong on 27/2/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

public protocol GroupsCellDelegte {
    func GroupsSelected(indexPath: IndexPath, identifier: String)
}

class GroupsCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let phCells = "PhotosCell"
    var image:UIImage?
    var items: Int = 0
    var text: String = ""
    var identifier:String? = nil
    
    var delegate: GroupsCellDelegte?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.collectionView.register(UINib(nibName: phCells, bundle: nil), forCellWithReuseIdentifier: phCells)
        self.collectionView.backgroundColor = .clear
        self.collectionView.layer.cornerRadius = 4
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

}


extension GroupsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = self.identifier else { print("not identifier key"); return}
        
        self.delegate?.GroupsSelected(indexPath: indexPath, identifier: identifier)
        print("\(identifier), \(indexPath.item)")
    }
}

extension GroupsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: phCells, for: indexPath) as! PhotosCell
        cell.thumbnailImage = image ?? #imageLiteral(resourceName: "preview")
        cell.addText(str: text)
        return cell
    }
    
}

extension GroupsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}
