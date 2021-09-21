//
//  Constants.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

/// AppDelegate shared instance.
// swiftlint:disable:next force_cast
let kAppDelegate = (UIApplication.shared.delegate as! AppDelegate)

/// Main Queue thread.
let kMainQueue = DispatchQueue.main

//MARK:- API
/// Declared further in APIConstants.swift class
///  This enum represent All the APi urls used in the app
extension API {
    /// Main Server Url
    static let serverURL = "https://xyz.com"
    
    /// Base URL for the Api's
    static let baseURL = "\(API.serverURL)/api/"
}

//MARK:- CREDENTIALS
/// Credentials
enum CREDENTIALS {
    
}

//MARK:- FOLDERS

/// FOLDER Names used in the system
enum FOLDERS {
    /// iCloud files folder 'icloud'
    static let icloud = "icloud"
    
    /// Saved files folder 'saved_files'
    static let savedFiles = "saved_files"
}

//MARK:- Default Center
///Abbr...
enum DefaultCenter {
    
    /// NotificationCenter
    static let notification = NotificationCenter.default
    
    /// FileManager
    static let fileManager = FileManager.default
    
    /// UserDefaults
    static let userDefaults = UserDefaults.standard
}

/// Common Keys used in Application
enum Keys {
    /// Logged In User info
    static let userData = "userData"
    
    /// Auth token of logged In user
    static let authToken = "authToken"
    
    /// Username
    static let username = "username"
    
    /// Password
    static let password = "password"
}

//MARK:- Background Queues
///QUEUES
enum BackgroundQueue {
    /// Queue for Common Operations
    static let commonQueue = DispatchQueue(label: "com.project.queue_common", qos: .background)
    
    /// Queue for Listing Operations
    static let listQueue = DispatchQueue(label: "com.project.queue_list", qos: .background)
    
    /// Queue for Listing Operations
    static let messageQueue = DispatchQueue(label: "com.project.queue_message", qos: .background)
    
    /// Queue for Listing Operations
    static let tokBoxQueue = DispatchQueue(label: "com.project.queue_tokbox", qos: .background)
    
    /// Queue for media download
    static let mediaDownloadQueue = DispatchQueue(label: "com.project.queue_media_download", qos: .background)
}

//MARK:- HTTP METHODS & CONTENT TYPE
///Extented further in EnumUtil.swift class
enum HttpMethods {}

/// Extented further in EnumUtil.swift class
enum ContentType {}

//MARK:- Device Constraints
///Extented further in EnumUtil.swift class
enum Screen {}
