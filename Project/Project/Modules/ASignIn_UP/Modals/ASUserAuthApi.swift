//
//  ASUserAuthApi.swift
//  Project
//
//  Created by Ankit Saini on 21/09/21.
//

import Foundation

/// User Api Modal
struct ASUserAuthApi {
    /// Login account.
    /// - Parameter request: Dictionary<String, Any>
    /// - Parameter completion: user: ASUser?, _ token: String?
    static func loginAccount(request: Dictionary<String, Any>, completion: @escaping(_ user: ASUser?, _ token: String?) -> Void) {
        
        ASUserAuthApi.checkAccount(request: request, url: API.login.strUrl()) { (_, user, token) in
            
            completion(user, token)
        }
    }
    
    /// Check Account for parameters and create new one
    /// - Parameter request: Dictionary<String, Any>
    /// - Parameter completion: msg: String,_ user: ASUser?, _ token: String?
    static private func checkAccount(request: Dictionary<String, Any>, url: String, completion: @escaping(_ msg: String, _ user: ASUser?, _ token: String?) -> Void) {
        if kAppDelegate.checkInternet() == false {
            completion("", nil, nil)
            return
        }
        kAppDelegate.showLoader()
        BackgroundQueue.commonQueue.async {
            ASDataModal.shared.requestPostDataApi(with: url, parameters: request) { (result: ASUser?, tuple) in
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                    if let info = tuple {
                        let msg = info.error.joined(separator: "\n")
                        completion(msg, result, tuple?.token)
                        return
                    }
                    completion("", nil, nil)
                    return
                }
            }
        }
    }
    
}
