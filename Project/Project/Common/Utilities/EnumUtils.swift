//
//  EnumUtils.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import UIKit

//MARK:- Device Constraints
extension Screen {
    /// Main Screen
    static let main = UIScreen.main
    /// Screen Width
    static let width = UIScreen.main.bounds.size.width
    ///Screen Height
    static let height = UIScreen.main.bounds.size.height
    /// Screen center width
    static let centerW = Screen.width/2
    /// Screen center height
    static let centerH = Screen.height/2
    /// UserInterfaceIdiom
    static let deviceIdiom = main.traitCollection.userInterfaceIdiom
    /// Is device Ipad?
    static let isIPAD: Bool = deviceIdiom == UIUserInterfaceIdiom.pad ? true : false
}

//
//MARK:-        [---------- STORYBOARD SETTINGS [START] ----------]
//
extension Storyboard {
    
    /// UIStoryboard instance
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    /// This function takes class name as argument and returns it’s instance. Using this, one can instantiate a ViewController as Storyboard.main.viewController(viewControllerClass: ViewController.self)
    ///
    /// - Parameter viewControllerClass: ViewController
    /// - Returns: Storyboard instance for viewControllerClass
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as? T
    }
}
//MARK:- UIViewController
extension UIViewController {
    
    /// String identifier of storyboard
    class var storyboardID: String {
        return "\(self)"
    }
}

//MARK:
//MARK:        [---------- STORYBOARD SETTINGS [END] ----------]
//MARK:-
/// HTTP METHODS
extension HttpMethods {
    /// GET Method
    static let get = "GET"
    /// POST Method
    static let post = "POST"
    /// PUT Method
    static let put = "PUT"
    /// PATCH Method
    static let patch = "PATCH"
    /// DELETE Method
    static let delete = "DELETE"
}

// MARK: - ContentType
extension ContentType {
    /// application/x-www-form-urlencoded
    static let applicationXWWFormUrlencoded = "application/x-www-form-urlencoded"
    /// application/json
    static let applicationJson = "application/json"
    /// multipart/form-data
    static let multipartFormData = "multipart/form-data"
}

///
// MARK:- Notification Name
///

/// This Enum is used to get the notification name.
enum Notifications: String {
    /// Remove splash
    case splashRemove
    
    /// Logout User
    case logout
    
    /// Name of the notification
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue )
    }
    
    /// String value
    var string: String {
        return self.rawValue
    }
}
//
//MARK:- Media Extensions
//
/// Media File Extensions
enum MediaExtension: String {
    /// PNG
    case png = "png"
    /// JPG
    case jpg = "jpg"
    /// JPEG
    case jpeg = "jpeg"
    /// MP4
    case mp4 = "mp4"
    /// DOC
    case doc = "doc"
    /// DOCX
    case docX = "docx"
    /// PDF
    case pdf = "pdf"
    /// XLS
    case xls = "xls"
    /// MP3
    case mp3 = "mp3"
    
    /// Name appended with (.)
    var dotName: String {
        return ".\(self.rawValue)"
    }
    
    /// Name
    var name: String {
        return self.rawValue
    }
}
