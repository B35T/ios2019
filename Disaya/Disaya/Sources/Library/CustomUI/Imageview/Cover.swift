//
//  Cover.swift
//  Disaya
//
//  Created by chaloemphong on 12/5/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit

open class Cover: UIImageView {

    @IBOutlet weak var logoImageView: UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func animation(point: CGPoint, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.frame.origin = point
        }
    }
    
    private func initialize() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        let logoImageView = UIImageView()
        self.logoImageView = logoImageView
        self.logoImageView.frame.size = .init(width: 184, height: 87)
        self.logoImageView.center = self.center
        self.logoImageView.contentMode = .scaleAspectFit
        self.insertSubview(self.logoImageView, at: 0)
        
        let logo = UIImage(named: "DisaLogo.png")
        self.logoImageView.image = logo
        
        let colorTop =  UIColor.black.withAlphaComponent(0).cgColor
        let colorBottom = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = .init(x: 0, y: self.frame.height - 200, width: self.frame.width, height: 200)
        
        self.layer.addSublayer(gradientLayer)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
