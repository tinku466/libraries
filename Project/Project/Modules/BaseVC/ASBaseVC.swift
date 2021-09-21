//
//  ASBaseVC.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import UIKit
import IQKeyboardManagerSwift

/// This is the base class for all the project controllers. Every controller must inherit this base class for reusability purpose.
class ASBaseVC: UIViewController {
    
    //MARK:- View Cycle
    
    /// View did load will load all the UI components.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        addLogoutNotifications()
    }
    
    //MARK:- USER STORE
    
    /// This will save the logged in user info and redirect to home screen
    /// - Parameter user: DPUser?
    /// - Parameter authToken: String
    func saveUserLogin(user: ASUser?, authToken: String) {
        ///
        /// Save user Info here
        ///
        AStorage.shared.saveUser(authToken: authToken)
        if let userProfile = user {
            AStorage.shared.saveUser(profile: userProfile)
        }
        if AStorage.shared.isUserLogin() {
            loadHomeScreen()
        }
    }
    
    // MARK:-
    // MARK: Navigation Bar
    
    /// This function is used to set the title of the navigation bar.
    ///
    /// - Parameters:
    ///   - withTitle: Bar Title
    ///   - font: Font
    ///   - color: Text Color
    ///   - navigationItem: UINavigationItem. if none passed then default will be used.
    func navBar(withTitle: String, font: UIFont = Font.navTitleBold, color: UIColor = .white, navigationItem: UINavigationItem? = nil) {
        if navigationItem == nil {
            self.navigationItem.title = withTitle
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        } else {
            navigationItem?.title = withTitle
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        }
        
    }
    
    /// This will be used to setup bar buttons in the navigation bar.
    ///
    /// - Parameters:
    ///   - left: Image of left button
    ///   - right: image of right button
    ///   - shouldBack: default back action should be back to previous controller.
    ///   - navigationItem: UINavigationItem. if none passed then default will be used.
    func navBarButtons(left: UIImage?, leftWidth: CGFloat = 40.0, right: UIImage?, shouldBack: Bool = false, navigationItem: UINavigationItem? = nil) {
        btnLeftMenu.frame = CGRect.init(x: 0, y: 0, width: leftWidth, height: 30)
        
        if shouldBack == true {
            btnLeftMenu.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        } else {
            btnLeftMenu.addTarget(self, action: #selector(navLeftClicked(sender:)), for: .touchUpInside)
        }
        
        if left != nil {
            btnLeftMenu.setImage(left, for: .normal)
        }
        btnLeftMenu.contentHorizontalAlignment = .left
        let item1 = UIBarButtonItem.init(customView: btnLeftMenu)
        
        btnRightMenu.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        btnRightMenu.addTarget(self, action: #selector(navRightClicked(sender:)), for: .touchUpInside)
        btnRightMenu.titleLabel?.font = Font.navButton
        if right != nil {
            btnRightMenu.setImage(right, for: .normal)
        }
        let item2 = UIBarButtonItem.init(customView: btnRightMenu)
        
        if navigationItem == nil {
            self.navigationItem.setLeftBarButtonItems([item1], animated: true)
            self.navigationItem.setRightBarButtonItems([item2], animated: true)
        } else {
            navigationItem?.setLeftBarButtonItems([item1], animated: true)
            navigationItem?.setRightBarButtonItems([item2], animated: true)
        }
        
    }
    
    // MARK:-
    // MARK: Action Methods
    // MARK:
    
    /// Action for left navigation bar button item
    ///
    /// - Parameter sender: caller responsible for the acton
    @objc func navLeftClicked(sender: UIButton) {
        print("left clicked")
    }
    
    /// Action for right navigation bar button item
    ///
    /// - Parameter sender: caller responsible for the acton
    @objc func navRightClicked(sender: UIButton) {
        print("right clicked")
    }
    
    /// Go back to previous controller using popViewController.
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Go back to previous controller using dismiss.
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- LOGOUT
    
    /// Clear the tokens and stored data and logout the user.
    @objc func logOut() {
        //
        //Remove singleton user data
        //
        Singleton.shared.clearData()
        
        //
        //Remove local stored data in defaults
        //
        AStorage.shared.clearStorage()
        
        //
        //Remove all files from temprary directory
        //
        let tempDirPath = DefaultCenter.fileManager.pathFor(.temprary)
        if tempDirPath != nil {
            _ = FileManager.removeAllItemsInsideDirectory(atPath: tempDirPath!)
        }
        
        //
        //Clear cookies
        //
        clearCacheCookies()
        
//        print("CURRENT CLASS NAME: ", UIApplication.topViewController()?.className ?? "nil")
        if UIApplication.topViewController()?.className == "ASignInVC" {
            return
        }
        
        kMainQueue.asyncAfter(deadline: .now() + 0.1) {
            guard let vc = Storyboard.login.viewController(viewControllerClass: ASignInVC.self) else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            let navVC = UINavigationController.init(rootViewController: vc)
            let transition = ASUtility.shared.getTransition(duration: 0.2, type: .moveIn, subType: .fromLeft)
            vc.view.layer.add(transition, forKey: kCATransition)
            
            kAppDelegate.window?.rootViewController = navVC
        }
    }
    
    //MARK:- LAZY INITIALIZERS
    
    /// Left navigation bar button
    lazy var btnLeftMenu: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        return btn
    }()
    
    /// Right navigation bar button
    lazy var btnRightMenu: UIButton = {
        return UIButton()
    }()
    
    lazy var lblNoData: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = Font(.systemItatic, size: .standard(.h4)).instance
        lbl.textColor = Color.darkText
        lbl.numberOfLines = 2
        return lbl
    }()
}

//MARK:- NAVIGATIONS
extension ASBaseVC {
    
    /// Load Home Screen
    func loadHomeScreen() {
        let vc = ASHomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TABLEVIEW HELPERS
///
extension ASBaseVC {
    /// No data lable setting of table view
    ///
    /// - Parameters:
    ///   - tblView: UITableView
    ///   - msg: String
    ///   - rows: Int
    ///   - frame: CGRect?
    func noDataSettings(tblView: UIScrollView, msg: String? = "No data available.", rows: Int = 0, frame: CGRect? = nil) {
        weak var weakSelf = self
        kMainQueue.async {
            guard let lbl = weakSelf?.lblNoData else { return }
            if rows == 0 {
                lbl.isHidden = false
                lbl.text = msg
                if frame == nil {
                    lbl.frame = CGRect.init(x: 10, y: tblView.frame.minX, width: tblView.frame.width, height: tblView.frame.height-40)
                } else {
                    lbl.frame = frame!
                }
                
                tblView.addSubview(lbl)
                
            } else {
                lbl.isHidden = true
            }
        }
    }
}

// MARK:-
// MARK: Keyboard Manager
extension ASBaseVC {
    
    /// Dismiss the keyboard
    func resignKeyboard() {
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    /// Go to next text field
    func gotoNextField() {
        if IQKeyboardManager.shared.canGoNext == true {
            _ = IQKeyboardManager.shared.goNext()
        }
    }
    
    /// Go to previous text field
    func gotoPrevField() {
        if IQKeyboardManager.shared.canGoPrevious == true {
            _ = IQKeyboardManager.shared.goPrevious()
        }
    }
}

//MARK:- NOTIFICATIONS
extension ASBaseVC {
    
    /// Logout Notification observer
    func addLogoutNotifications() {
        DefaultCenter.notification.removeObserver(self, name: Notifications.logout.name, object: nil)
        DefaultCenter.notification.addObserver(self, selector: #selector(logOut), name: Notifications.logout.name, object: nil)
    }
}
