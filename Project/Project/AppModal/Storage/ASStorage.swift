//
//  AStorage.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation

/// This class is resposible to store all values locally.
class AStorage {
    
    /// Shared Instance
    static let shared = AStorage()
    
    //MARK:- CLEAN UP
    /// Delete all locally stored data
    func clearStorage() {
        DefaultCenter.userDefaults.removeObject(forKey: Keys.userData)
        DefaultCenter.userDefaults.removeObject(forKey: Keys.authToken)
    }
    
    
    //MARK:- REMEMBER ME
    /// Save Username and password
    /// - Parameter username: String
    /// - Parameter password: String
    func save(username: String, password: String) {
        if username.isEmpty == true || password.isEmpty == true {
            DefaultCenter.userDefaults.removeObject(forKey: Keys.username)
            DefaultCenter.userDefaults.removeObject(forKey: Keys.password)
        } else {
            AStorage.shared.save(value: username, key: Keys.username)
            AStorage.shared.save(value: password, key: Keys.password)
        }
    }
    
    /// Get rememeber me details
    func getRememberMe() -> (username: String, Password: String) {
        
        guard let usernameData = DefaultCenter.userDefaults.data(forKey: Keys.username), let username = NSKeyedUnarchiver.unarchiveObject(with: usernameData) as? String else {
            return ("", "")
        }
        
        guard let passwordData = DefaultCenter.userDefaults.data(forKey: Keys.password), let password = NSKeyedUnarchiver.unarchiveObject(with: passwordData) as? String else {
            return ("", "")
        }
        
        return (username, password)
    }
    
    //MARK:- SAVE USER
    /// Save Auth Token for user
    /// - Parameter authToken: String
    func saveUser(authToken: String) {
        AStorage.shared.save(value: authToken, key: Keys.authToken)
    }
    
    /// Save user profile
    /// - Parameter profile: DPUser
    func saveUser(profile: ASUser) {
        do {
            let encoded = try JSONEncoder().encode(profile)
            AStorage.shared.save(user: encoded)
            
        } catch let error {
            print("Error in saving USER LOGGED IN object")
            print(error.localizedDescription)
        }
    }
    
    /// This function is used to save the information of login for one time login.
    ///
    /// - Parameter user: Dictionary object of user returned from Server at the time of login into Data() form.
    func save(user: Data) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        DefaultCenter.userDefaults.set(encodedData, forKey: Keys.userData)
    }
    
    //MARK:- UPDATE USER
    /// Update the user information
    ///
    /// - Parameter user: Data
    func update(user: Data) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
        DefaultCenter.userDefaults.set(encodedData, forKey: Keys.userData)
    }
    
    //MARK:- GET USER
    
    /// This function is used to get the information of user and load user modal.
    ///
    /// - Returns: true if user is logged in else false
    func isUserLogin() -> Bool {
        guard let authData = DefaultCenter.userDefaults.data(forKey: Keys.authToken), let authToken = NSKeyedUnarchiver.unarchiveObject(with: authData) as? String else {
            return false
        }
        Singleton.shared.strAuthToken = authToken
        
        // retrieving a value for a key
        if let rawData = DefaultCenter.userDefaults.data(forKey: Keys.userData), let info = NSKeyedUnarchiver.unarchiveObject(with: rawData) as? Data {
            if info.isEmpty == false {
                let user = try? JSONDecoder().decode(ASUser.self, from: info)
                Singleton.shared.user = user
            }
        }
        if Singleton.shared.strAuthToken.isEmpty == false {
            return true
        }
        return false
    }
    
    //MARK:- WRAPPER
    /// Save String value in Defaults
    ///
    /// - Parameters:
    ///   - value: String
    ///   - key: String
    func save(value: String, key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        DefaultCenter.userDefaults.set(encodedData, forKey: key)
    }
    
}
