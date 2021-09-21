//
//  ASResponseModal.swift
//  ASVideoApp
//
//  Created by Ankit Saini on 10/10/20.
//

import Foundation

/// Success Modal of APi Response
struct Success<T: Codable>: Codable {
    
    /// If request is success
    let isSuccess: Bool

    /// Error string of response
    let error: [String]?
    
    /// Data of response
    let data: T?
    
    /// Auth Token
    let token: String?
    
    private let msg: String?
    private let err: String?
    
    /// Keys for Response Modal
    enum CodingKeys: String, CodingKey {
        /// isSuccess
        case isSuccess = "status"
        
        /// error
        case msg = "msg"
        
        /// error
        case err = "error"
        
        //statusCode
        /// statusCode, data
        case data
        
        /// auth_token
        case token = "token"
    }
    
    /// Initializer
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = (try? values.decodeIfPresent(Bool.self, forKey: .isSuccess)) ?? false
        msg = try? values.decodeIfPresent(String.self, forKey: .msg)
        err = try? values.decodeIfPresent(String.self, forKey: .err)
        
        var arrErr: [String] = []
        if let m = msg {
            arrErr.append(m)
        }
        if let m = err {
            arrErr.append(m)
        }
        error = arrErr
        
        data = try? values.decodeIfPresent(T.self, forKey: .data)
        
        token = try? values.decodeIfPresent(String.self, forKey: .token)
    }
}

/// Response Tuples
struct ResponseTuples {
    
    /// Is Success
    let isSuccess: Bool
    
    /// Status code
    let statusCode: Int
    
    /// Error String
    let error: [String]
    
    /// Auth Token
    let token: String?
}
