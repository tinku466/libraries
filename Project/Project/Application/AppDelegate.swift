//
//  AppDelegate.swift
//  Project
//
//  Created by Mr. X on 21/09/21.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift

/// This is the first class after main which will be used to initialize project setups.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Default UIWindow instance.
    var window: UIWindow?
    
    /// Reachability instance to check network Reachability.
    let reachability = try? Reachability()
    
    //MARK:- APPLICATION CYCLE
    
    /// This will be called whenever application is newly launched.
    ///
    /// - Parameters:
    ///   - application: UIApplication instance.
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Returns true or false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // ---------------------------------------------------------
        // Enable Keyboard Manager
        //
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UITextField.appearance().keyboardAppearance = .light
        UINavigationBar.appearance().setColors(background: Color.lightGreen, text: .white)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        ///
        ///
        removeLocalMovieFiles()
        ///
        /// Monitor Internet
        internetMonitoring()
        
        ///
        /// --------------------- NOTIFICATION --------------
        /* ***********************************************************************
         *
         * Handle Notification click in case app is not active or in killed state
         *
         ************************************************************************ */
        
//        if launchOptions != nil {
//            // opened from a push notification when the app is Killed
//            let userInfo = launchOptions![UIApplication.LaunchOptionsKey.remoteNotification]
//            if userInfo != nil, let info = userInfo as? Dictionary<String, Any> {
//                kMainQueue.asyncAfter(deadline: .now() + 0.6) {[weak self] in
//                    print(info)
//                    self?.handlePushNotification(userInfo: info, completionHandler: { (_) in
//                    })
//                }
//            }
//        }
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        // Use Firebase library to configure APIs
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
        
        
        return true
    }
}
