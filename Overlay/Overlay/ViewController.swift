
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var overlayScroll: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var selectLayer: UIView!
    var deleteItem:UIButton!
    
    var over:[Int:UIImageView] = [:]
    var tags = 0
    var choose:Int? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overlayScroll.frame = .init(x: 0, y: 0, width: mainImageView.frame.width, height: mainImageView.frame.height)
        
        let layer = UIView()
        self.selectLayer = layer
        self.selectLayer.frame.size = .init(width: 200, height: 200)
        self.selectLayer.layer.borderColor = UIColor.white.cgColor
        self.selectLayer.isUserInteractionEnabled = true
        self.selectLayer.layer.borderWidth = 1
        
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        pan.delegate = self
        selectLayer.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(reconizer:)))
        pinch.delegate = self
        selectLayer.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(reconizer:)))
        rotate.delegate = self
        selectLayer.addGestureRecognizer(rotate)
        
        
        let deleteItem = UIButton()
        self.deleteItem = deleteItem
        self.deleteItem.frame.size = .init(width: 30, height: 30)
        self.deleteItem.setBackgroundImage(UIImage(named: "close.png"), for: .normal)
        self.deleteItem.layer.cornerRadius = 15
        self.deleteItem.addTarget(self, action: #selector(deleteItemAction), for: .touchUpInside)
        self.deleteItem.clipsToBounds = true
        
    }
    
    func updateDeleteButton() {
        self.deleteItem.center = .init(x: self.selectLayer.frame.minX, y: self.selectLayer.frame.minY)
    }
    
    @IBAction func deleteItemAction(_ sender: UIButton) {
        if let i = self.choose {
            self.over[i]?.removeFromSuperview()
        
        }
    }
    
    func tracking(center: CGPoint) {
        self.over[self.choose ?? 0]?.center = center
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let overlay = UIImageView()
        overlay.frame.size = .init(width: 200, height: 200)
        overlay.tag = self.tags
        overlay.center = self.mainImageView.center
        overlay.isUserInteractionEnabled = true
        overlay.image = UIImage(named: "light3.png")
        overlay.layer.compositingFilter = "screenBlendMode"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(reconizer:)))
        overlay.addGestureRecognizer(tap)
        
        self.view.addSubview(self.overlayScroll)
        self.overlayScroll.addSubview(overlay)
        self.over.updateValue(overlay, forKey: self.tags)
        self.overlayScroll.addSubview(self.selectLayer)
        self.tags += 1
        
    }
    
    @IBAction func pickerAction(_ sender:UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view, view.tag == self.choose {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            self.updateDeleteButton()
            self.tracking(center: view.center)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func handlePinch(reconizer:UIPinchGestureRecognizer) {
        if let view = reconizer.view, view.tag == self.choose {
            view.transform = view.transform.scaledBy(x: reconizer.scale, y: reconizer.scale)
            self.updateDeleteButton()
            
            reconizer.scale = 1
        }
    }
    
    @IBAction func handleRotation(reconizer: UIRotationGestureRecognizer) {
        if let view = reconizer.view, view.tag == self.choose {
            view.transform = view.transform.rotated(by: reconizer.rotation)
            self.updateDeleteButton()
            
            reconizer.rotation = 0
        }
    }
    
    @IBAction func handleTap(reconizer: UITapGestureRecognizer) {
        
        if let view = reconizer.view {
            self.choose = view.tag
            print(view.tag)
            self.selectLayer.center = view.center
            self.deleteItem.alpha = 1
            self.overlayScroll.addSubview(self.selectLayer)
            self.overlayScroll.addSubview(self.deleteItem)
            self.updateDeleteButton()
        } else {
            print("no view")
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension ViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.mainImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
