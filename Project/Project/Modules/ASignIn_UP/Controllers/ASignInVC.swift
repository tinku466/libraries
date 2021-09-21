//
//  ASignInVC.swift
//  Project
//
//  Created by Ankit Saini on 21/09/21.
//

import UIKit

class ASignInVC: ASBaseVC {
    ///
    /// PROPERTIES
    ///
    ///
    /// OUTLETS
    ///
    /// Email View
    @IBOutlet weak var viewEmail: ASFormFieldView!
    
    /// Password View
    @IBOutlet weak var viewPwd: ASFormFieldView!
    
    //MARK:- VIEW CYCLE
    /// Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        ///
        ///
        setupUI()
        ///
        ///
        if AStorage.shared.isUserLogin() {
            loadHomeScreen()
        }
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- SETUP UI
    /// Setup UI
    private func setupUI() {
        viewEmail.textField.addPaddingLeftIcon(#imageLiteral(resourceName: "tf_email"), padding: 8.0)
        viewEmail.textField.tintColor = Color.textFieldActiveColor
        
        viewPwd.textField.addPaddingLeftIcon(#imageLiteral(resourceName: "tf_password"), padding: 8.0)
        viewPwd.textField.tintColor = Color.textFieldActiveColor
        viewPwd.textField.isSecureTextEntry = true
    }
    
    /// Setup Remember me options
    private func setupRememberMe() {
        let credentials = AStorage.shared.getRememberMe()
        if credentials.username.isEmpty == false && credentials.Password.isEmpty == false {
            viewEmail.textField.text = credentials.username
            viewPwd.textField.text = credentials.Password
        } else { //Empty the textfields even if one of the credentials available
            viewEmail.textField.text = ""
            viewPwd.textField.text = ""
        }
    }
    
    //MARK:- ACTIONS
    
    /// Sign In Action
    @IBAction func actSingIN() {
        resignKeyboard()
        if isValid() == false {
            return
        }
        loginAccountAPi()
        
    }
    
    //MARK:- VALIDATION
    
    /// Is Input Valid to forms.
    private func isValid() -> Bool {
        if viewEmail.textField.text?.isEmpty == true {
            ASUtility.shared.dissmissAlert(title: "", message: L10n.pleaseEnterEmailUsername.string, lblDone: L10n.ok.string)
            return false
        }
        if viewPwd.textField.text?.isEmpty == true {
            ASUtility.shared.dissmissAlert(title: "", message: L10n.noPwd.string, lblDone: L10n.ok.string)
            return false
        }
        
        return true
    }
}

//MARK:- API
extension ASignInVC {
    /// Register the Account
    func loginAccountAPi() {
        loadHomeScreen()
        /*weak var weakSelf = self
        
        let email = viewEmail.textField.text ?? ""
        let password = viewPwd.textField.text ?? ""
        
        let param: Dictionary<String, Any> = [
            "email": email,
            "password": password,
            "device_type": "ios"
        ]
        ASUserAuthApi.loginAccount(request: param) { (user, token) in
            guard let authToken = token else {
                return
            }
            ///
            /// Save Remember me
//            AStorage.shared.save(username: email, password: password)
            ///
            ///
            ///
            /// Save user Info here
            ///
            weakSelf?.saveUserLogin(user: user, authToken: authToken)
            return
            
        }*/
    }
}
