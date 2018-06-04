//
//  UIImage+Util.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 29/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeToApprox(sizeInMB: Double, deltaInMB: Double = 0.2) -> Data {
        let allowedSizeInBytes = Int(sizeInMB * 1024 * 1024)
        let deltaInBytes = Int(deltaInMB * 1024 * 1024)
        let fullResImage = UIImageJPEGRepresentation(self, 1.0)
        if (fullResImage?.count)! < Int(deltaInBytes + allowedSizeInBytes) {
            return fullResImage!
        }
        
        var i = 0
        
        var left:CGFloat = 0.0, right: CGFloat = 1.0
        var mid = (left + right) / 2.0
        var newResImage = UIImageJPEGRepresentation(self, mid)
        
        while (true) {
            i += 1
            if (i > 13) {
                print("Compression ran too many times ") // ideally max should be 7 times as  log(base 2) 100 = 6.6
                break
            }
            
            
            print("mid = \(mid)")
            
            if ((newResImage?.count)! < (allowedSizeInBytes - deltaInBytes)) {
                left = mid
            } else if ((newResImage?.count)! > (allowedSizeInBytes + deltaInBytes)) {
                right = mid
            } else {
                print("loop ran \(i) times")
                return newResImage!
            }
            mid = (left + right) / 2.0
            newResImage = UIImageJPEGRepresentation(self, mid)
            
        }
        
        return UIImageJPEGRepresentation(self, 0.5)!
    }
}
