//
//  CameraViewModels.swift
//  FLIM2019
//
//  Created by chaloemphong on 3/7/2562 BE.
//  Copyright © 2562 charoemphong. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewModeleDelegate {
    func output(image:UIImage?, cover: UIImage?)
}

open class CameraViewModels: UIViewController {

    private var captureSession: AVCaptureSession!
    private var backCamDevice: AVCaptureDevice!
    private var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private var inputBackCamDevice: AVCaptureDeviceInput!
    
    var delegate: CameraViewModeleDelegate?
    
    override open func loadView() {
        super.loadView()
        
        self.captureSession = AVCaptureSession()
        self.backCamDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        self.photoOutput = AVCapturePhotoOutput()
        self.previewLayer = AVCaptureVideoPreviewLayer()
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func initailize(preview: UIView) {
        do {
            self.inputBackCamDevice = try AVCaptureDeviceInput(device: self.backCamDevice)
        } catch {
            fatalError("errr camera input")
        }
        
        self.captureSession.sessionPreset = .photo
        self.captureSession.addInput(self.inputBackCamDevice)
        self.captureSession.startRunning()
        
        // setting preview
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame.size = preview.frame.size

        preview.layer.addSublayer(self.previewLayer)
        
        self.captureSession.addOutput(self.photoOutput)
    }
    
    func updatePreviewLayer(frame:CGRect) {
        self.previewLayer.frame.size = frame.size
    }
    
    func startRunning() {
        self.captureSession?.startRunning()
    }
    
    func stopRunning() {
        self.captureSession?.stopRunning()
    }
    
    func capture(flash: Bool = false) {
        guard let device = self.photoOutput else {return}
        let setting = AVCapturePhotoSettings()
        if setting.availablePreviewPhotoPixelFormatTypes.count > 0 {
            setting.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey : setting.availablePreviewPhotoPixelFormatTypes.first!,
                kCVPixelBufferWidthKey : 512,
                kCVPixelBufferHeightKey : 512
                ] as [String: Any]
        }
        setting.flashMode = flash ? .on : .off
        device.capturePhoto(with: setting, delegate: self)
    }
  
    func autoFocus(action:Bool = false) {
        guard let device = self.backCamDevice else {return}
        do {
            try device.lockForConfiguration()
            device.focusMode = action ? .continuousAutoFocus : .locked
            device.unlockForConfiguration()
        } catch {
            fatalError("err AF mode")
        }
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }

}

extension CameraViewModels: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print("delegate action")
        guard error == nil, let photoSimpleBuffer = photoSampleBuffer else {
            print("not access to photo buffer ")
            return
        }
        
        guard let imageDataInBuffer = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSimpleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {return}

        let cover = previewPhotoSampleBuffer?.image()

        if let photo = UIImage.init(data: imageDataInBuffer) {
            print(cover?.size)
            self.delegate?.output(image: photo, cover: cover)
        }
    }
}


extension CMSampleBuffer {
    func image(orientation: UIImage.Orientation = .up,
               scale: CGFloat = 1.0) -> UIImage? {
        if let buffer = CMSampleBufferGetImageBuffer(self) {
            let ciImage = CIImage(cvPixelBuffer: buffer)
            let colorInvert = ciImage.applyingFilter("CIColorInvert", parameters: [:])
            return UIImage(cgImage: colorInvert.toCGImage!, scale: scale, orientation: orientation)
        }
        
        return nil
    }
}
