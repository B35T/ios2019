
import UIKit

open class CustomLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initailize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initailize()
    }
    
    open func add(view:UIView,_ p: CGPoint, _ s:CGSize) {}
    
    open func x(view: UIView) {}
    
    open func animatedHidden(action:Bool = true, time: TimeInterval = 0.3) {
        UIView.animate(withDuration: time) {
            if action {
                self.alpha = 0
            } else {
                self.alpha = 1
            }
        }
    }
    
    open func remove() {
        self.removeFromSuperview()
    }
    
    open func initailize() {}
    
}
