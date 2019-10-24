//
//  UserLogin.swift
//  SwiftProject
//
//  Created by Gaurav Murghai on 20/03/19.
//  Copyright © 2019 Ankit Saini. All rights reserved.
//

import Foundation
import UIKit

class UserLogin {
    static func authenticateUser(with parameters: Dictionary<String, Any>, controller: UIViewController? = nil, completion: @escaping (_ user: Person?, _ accessToken: String?) -> Void) {
        if kAppDelegate.checkInternet() == false {
            completion(nil, nil)
            return
        }
        
        BackgroundQueue.loginQueue.async {
            ASDataModal.shared.requestPostDataApi(with: API.login.strUrl(), parameters: parameters, completion: { (res: DataResponse?, tuples) in
                kMainQueue.async {
                    kAppDelegate.hideLoader()
                    if tuples.isSuccess == true {
                        completion(res?.person, res?.accessToken)
                        return
                    }
                    completion(nil, nil)
                    return
                }
            })
        }
    }
    
    static func pollUserUpdates(with parameters: Dictionary<String, Any>, controller: UIViewController? = nil, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        completion(true)
    }
}
