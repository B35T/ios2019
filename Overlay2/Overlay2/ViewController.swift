

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var overframe: Overframe!
    @IBOutlet weak var noneframe: UIView!
    
    override func loadView() {
        super.loadView()
        
        let scrollView = UIScrollView()
        self.scrollView = scrollView
        self.scrollView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 550)
        self.view.addSubview(self.scrollView)
        
        let imageView = UIImageView()
        self.imageView = imageView
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 550)
        self.scrollView.addSubview(self.imageView)
        
        let overframe = Overframe()
        self.overframe = overframe
        self.overframe.add(view: self.view)
        self.overframe.center = scrollView.center
        self.overframe.isUserInteractionEnabled = true

        let move = UIPanGestureRecognizer(target: self, action: #selector(self.movePan(_:)))
        self.overframe.addGestureRecognizer(move)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.rotation(_:)))
        self.overframe.addGestureRecognizer(rotate)
        
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(self.zooming(_:)))
        self.overframe.addGestureRecognizer(zoom)
        
        let close = UIButton()
        self.close = close
        self.close.frame.size = .init(width: 20, height: 20)
        self.close.frame.origin = .init(x: -5, y: -5)
        self.close.layer.cornerRadius = 10
        self.close.backgroundColor = .white
        
        self.overframe.addSubview(self.close)
       
        
        let noneframe = UIView()
        self.noneframe = noneframe
        noneframe.frame.size = .init(width: 200, height: 200)
        noneframe.backgroundColor = .yellow
//        self.noneframe.center = self.overframe.center
        self.overframe.addSubview(self.noneframe)
        
        
        
//        self.overframe.transform = CGAffineTransform(rotationAngle: 45 * .pi / 180)
//        self.overframe.transform.rotated(by: 90 * .pi / 180)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func addImageAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addOverlayAction(_ sender: Any) {
        
    }
    
}

extension ViewController {
    @objc internal func zooming(_ sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else {return}
        self.noneframe.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
        self.noneframe.transform = .identity
        view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        sender.scale = 1
    }
    
    @objc internal func rotation(_ sender: UIRotationGestureRecognizer) {
        guard let view = sender.view else {return}
        
        print(CGFloat(90 * CGFloat.pi / 180))
        print("rotation \(sender.rotation)")
        view.transform = view.transform.rotated(by: sender.rotation)
        self.noneframe.transform = view.transform.rotated(by: sender.rotation)
        self.noneframe.transform = .identity
        sender.rotation = 0
    }
    
    @objc internal func movePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        guard let view = sender.view else {return}
        view.center = .init(x: view.center.x + translation.x, y: view.center.y + translation.y)
//        self.noneframe.center = view.center
        sender.setTranslation(.zero, in: self.view)
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
