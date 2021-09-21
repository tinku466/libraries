//
//  AppDelegate+Helpers.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation
import SVProgressHUD
import UIKit

/// COMMON HELERS
extension AppDelegate {
    
    //MARK:- FILEMANAGER
    
    /// Remove All files stored in document directory of mov exension
    @objc func removeLocalMovieFiles() {
        guard let dirUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let arrExts = ["mov", "m4v", "mp4", "m4a", "jpg", "png"]
        ///
        /// Remove cropped folder files as well
        let croppedDirUrl = dirUrl.appendingPathComponent(FOLDERS.savedFiles, isDirectory: true)
        
        arrExts.forEach { (ext) in
            FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: ext)
            FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: ext.uppercased())
            
            FileManager.removeAllItemsInsideDirectory(at: croppedDirUrl, with: ext)
        }
//        FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: "mov")
//        FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: "m4v")
//        FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: "mp4")
//        FileManager.removeAllItemsInsideDirectory(at: dirUrl, with: "m4a")
//        FileManager.removeAllItemsInsideDirectory(at: croppedDirUrl, with: "mp4")
        
        
    }
    
    //MARK:- LOADERS
    
    /// This function is used to show the spinning loader on view and hide the loader from the view.
    ///
    /// - Parameters:
    ///   - title: This will be written under the spinner.
    ///   - isOn: This will disable the user interaction to app if true.
    @objc func showLoader(with title: String? = L10n.loading.string, interaction isOn: Bool = false) {
        kMainQueue.async {
            if isOn == false {
                self.screenInteraction(enable: false)
            }
            SVProgressHUD.show(withStatus: title)
        }
    }
    
    /// This will replace the title under the spinning loader.
    ///
    /// - Parameter title: New title to replace with.
    func replaceLoader(title: String = "") {
        kMainQueue.async {
            SVProgressHUD.setStatus(title)
        }
    }
    
    /// Show loader with progress bar
    /// - Parameters:
    ///   - progress: Float
    ///   - status: String
    ///   - isOn: This will disable the user interaction to app if false.
    func showProgressLoader(progress: Float, status: String, interaction isOn: Bool = false) {
        kMainQueue.async {
            if isOn == false {
                self.screenInteraction(enable: false)
            }
            SVProgressHUD.showProgress(progress, status: status)
        }
    }
    
    /// Hide the spinning loader
    @objc func hideLoader() {
        kMainQueue.async {
            self.screenInteraction(enable: true)
            SVProgressHUD.dismiss()
        }
    }
    
    /// This will enable/disable the screen interactions during any specific event.
    ///
    /// - Parameter enable: If passed True then interaction will start otherwise if passed False then interaction will be stopped.
    func screenInteraction(enable: Bool) {
        if enable == true {
            if UIApplication.shared.isIgnoringInteractionEvents == true { //If already ignoring the screen touch's
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        } else {
            if UIApplication.shared.isIgnoringInteractionEvents == false { //If not already ignoring the screen touch's
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
}
//MARK:- INTERNET
extension AppDelegate {
    /// Used to check the internet is available or not. Return bool to controll further processings.
    ///
    /// - Parameter toast: weather to show toast if not connected or not.
    /// - Returns: return true if internet is connected else return false.
    func checkInternet(with toast: Bool = true) -> Bool {
        if let connection = reachability?.connection {
            switch connection {
            case .cellular:
                print("internet connected: cellular")
                return true
            case .unavailable, .none:
                if toast == true {
                    kMainQueue.async {
                        ASUtility.shared.showToast(with: L10n.noInternet.string, completion: {})
                    }
                }
                print("internet not connected: unavailable - none")
                return false
            case .wifi:
                print("internet connected: wifi")
                return true
            }
        }
        print("internet not connected: nil")
        return false
    }
    
    
    /// Start monitoring the internet continueusly.
    func internetMonitoring() {
        DefaultCenter.notification.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        DefaultCenter.notification.addObserver(self, selector: #selector(checkReachability(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        do {
            try reachability?.startNotifier()
        } catch let err {
            print("+++++++++++ ERROR IN INTERNET +++++++++++++++++")
            print(err.localizedDescription)
        }
    }
    
    /// This will be called whenever network reachability changed
    ///
    /// - Parameter notification: NSNotification of the observer.
    @objc func checkReachability(notification: NSNotification) {
        
        if checkInternet(with: false) == true {
            print("INTERNET Connected")
            
        } else {
            print("INTERNET DIS-Connected")
        }
        
    }
}

//MARK:- SHARE
extension AppDelegate {
    
    /// This function is used to share link through activity sheet.
    /// - Parameter title: String?
    /// - Parameter image: UIImage?
    func shareOnSocial(title: String?, image: UIImage?) {
        // text to share
        
        var arrData: [Any] = []
        
        if title != nil {
            arrData.append(title as Any)
        }
        
        if image != nil {
            arrData.append(image as Any)
        }
        
        /// Get Controller
        guard let controller = UIApplication.topViewController() else { return }
        
        // set up activity view controller
        
        let activityViewController = UIActivityViewController(activityItems: arrData, applicationActivities: nil)
        if Screen.isIPAD {
            activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
        }
        
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        controller.present(activityViewController, animated: true, completion: nil)
    }

    //MARK:- CUSTOM ALERT POPUP
    
    /// Show custom alert popup modal
    /// - Parameter title: title of alert
    /// - Parameter message: message of alert
    /// - Parameter doneTitle: done button title 'default is YES'
    /// - Parameter cancelTitle: cancel button title 'default is CANCEL'
    /// - Parameter completion: choice: Bool
    func showCustomAlert(title: String, message: String, doneTitle: String? = "YES", cancelTitle: String? = "CANCEL", config: ASAlertConfiguration? = nil, completion: @escaping(_ choice: Bool, _ vc: ASAlertPopUP?) -> Void) {
        guard let controller = UIApplication.topViewController() else { return }
        
        guard let vc = Storyboard.alertPopUP.viewController(viewControllerClass: ASAlertPopUP.self) else { return }
        
        vc.modalPresentationStyle = .overFullScreen
        
        if let conf = config {
            vc.config = conf
        }
        
        vc.strTitle = title
        vc.strMessage = message
        vc.buttonDoneTitle = doneTitle
        vc.buttonCancelTitle = cancelTitle
        
        controller.present(vc, animated: true, completion: nil)
        
        vc.onSelection = {(_ choice: Bool) in
            kMainQueue.asyncAfter(deadline: .now() + 0.2) {
                completion(choice, vc)
            }
        }
    }
}
