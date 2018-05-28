//
//  RegisterViewController.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 26/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import UIKit
import AVFoundation
import AWSRekognition

class RegisterViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    let captureSession = AVCaptureSession()
    let cameraOutput = AVCapturePhotoOutput()
    let awsRekognition = AWSRekognition.default()
    
    var faceId = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            
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
    
    func indexFaceWithAWSRekognition (faceImage: UIImage) {
        
        let image = AWSRekognitionImage()
        image?.bytes = UIImageJPEGRepresentation(faceImage, 1.0)
        
        let request = AWSRekognitionIndexFacesRequest()
        request?.collectionId = "firstCollection"
        request?.externalImageId = "some_random_string"
        request?.detectionAttributes = [String]()
        request?.image = image
        awsRekognition.indexFaces(request!) { (response, error) in
//            response?.faceRecords[0].face.faceId
            
            // Rahul indexes
            // "f1d2754e-2adb-4172-8984-a3d70e524118"
            // e2a32fa6-5d28-49aa-9b7a-e177d5c83e5b
            // 641b5130-addf-47fa-b214-14157e7e3ef3
            // c23cbea8-c9e1-4ff6-ae3f-ef01f032977c
            
            // handle 0 or many faces
            
            if response?.faceRecords?.count != 1 {
                print("non 1 face record ")
                return
            }
            
            self.faceId = (response?.faceRecords![0].face?.faceId)!
            
            // TODO : here use the Dispatch Group with uploading the image and
            self.enterNameAlertBox()

        }
        
        
    }
    
    func enterNameAlertBox() {
        let alert = UIAlertController(title: "Enter name", message: "Name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Full name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField!.text))")
            
            UserDefaults.standard.set(textField?.text!, forKey: self.faceId)
            
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        // TODO : if expanding this.. Can optimize on this part .. here data to image transfers too many
        let uiImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
        indexFaceWithAWSRekognition(faceImage: uiImage!)
    }
    
}
