//
//  DetectFaceViewController.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 26/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import UIKit
import AVFoundation
import AWSRekognition
import Toast_Swift

class DetectFaceViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession()
    let cameraOutput = AVCapturePhotoOutput()
    let metaDataOutput = AVCaptureMetadataOutput()
    
    let awsRekognition = AWSRekognition.default()
    
    
    var throttledCapture: Throttler?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        throttledCapture = Throttler(delay: 2, callback: {
            self.captureImage()
        })
        
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
    
    func captureImage() {
        
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg, AVVideoCompressionPropertiesKey: [AVVideoQualityKey : NSNumber(value: 1.0)]])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        // UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
        
        searchFaceWithAWSRekognition(faceImage: UIImage(data: imageData!)!)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        throttledCapture?.call()
    }
    
    func searchFaceWithAWSRekognition (faceImage: UIImage) {
        let image = AWSRekognitionImage()
        image?.bytes = faceImage.resizeToApprox(sizeInMB: 0.6)// UIImageJPEGRepresentation(faceImage, 0.7)
        
        let request = AWSRekognitionSearchFacesByImageRequest()
        request?.collectionId =  "secondCollection"
        request?.faceMatchThreshold = 95 as NSNumber
        request?.image = image
        request?.maxFaces = 3
        
        DispatchQueue.main.async {
            self.view.makeToast("Uploading... ")
        }
        
        awsRekognition.searchFaces(byImage: request!) { (response, error) in
            
            if (response?.faceMatches?.count != 1) {
                return
            }
            
            let faceId = response?.faceMatches![0].face?.faceId
            
            print(faceId!)
            let name = UserDefaults.standard.string(forKey: faceId!) ?? "Unknown"
            let sentence =  "Hello \(name)"
            DispatchQueue.main.async {
                self.view.makeToast(sentence)
            }
            
            let utterance = AVSpeechUtterance(string: sentence)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)

            
        }
    }
}

class Throttler: NSObject {
    var callback: (() -> ())
    var delay: Double
    var lastCalledAt: TimeInterval = 0.0
    
    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        fireNow()
    }
    
    func fireNow() {
        let currentTime =  Date().timeIntervalSince1970
        if currentTime < lastCalledAt + delay {
            return
        }
        self.callback()
        lastCalledAt = currentTime
    }
}






