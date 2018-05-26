//
//  ViewController.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 26/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {
                print("No Camera access")
            }
        }
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                } else {
                    print("no photo access")
                }
            })
        }

    }
}

