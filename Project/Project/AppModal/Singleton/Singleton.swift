//
//  Singleton.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation

/// This is a singleton class to store data during app cycle
class Singleton: NSObject {
    
    /// Shared instance
    static let shared = Singleton()
    
    /// String
    var strAuthToken: String = ""
    
    /// Push notification token for device
    var strDeviceToken: String?
    
    /// Logged In User info
    var user: ASUser?
    
    //MARK:- HELPERS
    
    /// Delete all local stored data in singleton
    func clearData() {
        strAuthToken = ""
        user = nil
    }
    
    /// Get header with authentication token for api requests
    func getAuthHeader() -> Dictionary<String, String> {
        if Singleton.shared.strAuthToken.isEmpty == false {
            return [
                "Content-Type": ContentType.applicationJson,
                "Authorization": "Bearer \(Singleton.shared.strAuthToken)",
                "Accept": "application/json"
            ]
        }
        return [
            "Content-Type": ContentType.applicationJson,
            "Accept": "application/json"
        ]
    }
}
