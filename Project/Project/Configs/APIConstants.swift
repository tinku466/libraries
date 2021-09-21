//
//  APIConstants.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation

//MARK:- API

/// Extented further in Constant.swift class
///  This enum represent All the APi urls used in the app
enum API: String {
    /// Login end-point
    case login
    
    /// device/token
    case deviceToken = "device/token"
}

//
//MARK:-        [---------- API Extends ----------]
/// API Extensions
extension API {
    
    /// String value of url
    var val: String {
        return self.rawValue
    }
    
    /// URL with base url
    ///
    /// - Parameter mainURL: base url string
    /// - Returns: URL created using base url passed.
    func url(with mainURL: String = API.baseURL) -> URL? {
        let url = "\(mainURL)\(self.val)"
        return URL.init(string: url)
    }
    
    /// String value with base url
    ///
    /// - Parameter mainURL: base url
    /// - Returns: base url + url into string form.
    func strUrl(with mainURL: String = API.baseURL) -> String {
        return "\(mainURL)\(self.val)"
    }
}
