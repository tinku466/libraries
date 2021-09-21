//
//  DJPermissions.swift
//  DJme
//
//  Created by Ankit Saini on 17/06/20.
//  Copyright © 2020 softobiz. All rights reserved.
//

import Foundation
import Photos
import StoreKit

/// Class to represent all permissions needed in project
class DJPermissions: NSObject {
    
    /// Permission type
    enum PermissionType {
        /// Gallery permissions
        case gallery
    }
    
    /// SHared instance
    static let shared: DJPermissions = DJPermissions()
    
    /// Permission Type
    private var type: PermissionType = .gallery {
        didSet {
            switch type {
            case .gallery:
                requestGalleryPermissions()
            }
        }
    }
    
    //MARK:- COMPLETION HANDLERS
    /// When option is picked then this callback will be returned with selected values
    var onCompletion: ((_ status: Bool) -> Void)?
    
    //MARK:- INIT
    
    /// ReQuest a permission
    /// - Parameter type: PermissionType
    func requestPermision(for type: PermissionType) {
        self.type = type
    }
    
    //MARK:- Gallery Permissions
    
    /// Request for gallery access permission
    private func requestGalleryPermissions() {
        weak var weakSelf = self
        //Photos
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("Gallery - authorized")
            onCompletion?(true)
        case .denied:
            print("Gallery - denied")
        case .notDetermined:
            print("Gallery - notDetermined")
            askGalleryPermission { (_) in
                weakSelf?.onCompletion?(true)
            }
        case .restricted:
            print("Gallery - restricted")
            onCompletion?(true)
        default:
            onCompletion?(false)
        }
    }
    
    /// Ask for gallery permission
    private func askGalleryPermission(completion: @escaping(_ status: PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            completion(status)
        }
    }
}
