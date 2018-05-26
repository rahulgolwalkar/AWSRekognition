//
//  RegisterViewController.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 26/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import UIKit
import AVFoundation

class RegisterViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {

    let captureSession = AVCaptureSession()
    let cameraOutput = AVCapturePhotoOutput()
    let metaDataOutput = AVCaptureMetadataOutput()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.face]
            
            captureSession.startRunning()
            
            cameraOutput.isHighResolutionCaptureEnabled = true
            captureSession.addOutput(cameraOutput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            previewLayer.frame = self.view.bounds
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            self.view.layer.insertSublayer(previewLayer, at: 0)
        } catch {
            print("Could not add the camera to the session with error : ", error)
        }

    }
    
    @IBAction func captureClicked(_ sender: Any) {
        
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg, AVVideoCompressionPropertiesKey: [AVVideoQualityKey : NSNumber(value: 1.0)]])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)

    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("Detected  face")
    }

}
