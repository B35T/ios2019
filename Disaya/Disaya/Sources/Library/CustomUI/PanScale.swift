
import UIKit

protocol PanScaleDelegetes {
    func PanAction(value:CGFloat)
}


class PanScale {
    public var value:CGFloat = 1.0
    public var view:UIView!
    
    public var delegate:PanScaleDelegetes?
    
    init(view:UIView) {
        self.view = view
        self.view.accessibilityIdentifier = "PopulrPan"
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(PanAction(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(pan)
    }
    
    @objc internal func PanAction(_ sender:UIPanGestureRecognizer) {
        let tr = sender.translation(in: self.view)
        self.value += (-tr.y / self.view.frame.height)
        
        if self.value >= 0.0 && self.value <= 1.0 {
            self.delegate?.PanAction(value: self.value)
        }
        
        switch sender.state {
        case .ended:
            if self.value > 0.99 {
                self.value = 1.0
                self.delegate?.PanAction(value: 1.0)
            }
            
            if self.value < 0.01 {
                self.value = 0.0
                self.delegate?.PanAction(value: 0.0)
            }
            break
        default:
            break
        }
        
        sender.setTranslation(.zero, in: self.view)
    }
}
