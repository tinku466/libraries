//
//  ASUser.swift
//  Project
//
//  Created by Ankit Saini on 21/09/21.
//

import Foundation

/// User Modal
struct ASUser: Codable {
    let id: String
    var name: String?
    var email: String?
    var phone: String?
    var countryCode: String?
    var profilePhoto: String?
    var dob: String?
    var userType: String
    var deviceType: String?
    var status: Int?
    let createdAt: String?
    
    init() {
        self.id = ""
        self.name = nil
        self.email = nil
        self.phone = nil
        self.countryCode = nil
        self.profilePhoto = nil
        self.dob = nil
        self.userType = ""
        self.deviceType = nil
        self.status = nil
        self.createdAt = nil
    }
    
    /// CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case countryCode = "country_code"
        case profilePhoto = "profile_photo"
        case dob
        case userType = "user_type"
        case deviceType = "device_type"
        case status
        case createdAt = "created_at"
    }
    
    /// Initializer
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        email = try? values.decodeIfPresent(String.self, forKey: .email)
        phone = try? values.decodeIfPresent(String.self, forKey: .phone)
        countryCode = try? values.decodeIfPresent(String.self, forKey: .countryCode)
        profilePhoto = try? values.decodeIfPresent(String.self, forKey: .profilePhoto)
        dob = try? values.decodeIfPresent(String.self, forKey: .dob)
        userType = try values.decodeIfPresent(String.self, forKey: .userType) ?? ""
        deviceType = try? values.decodeIfPresent(String.self, forKey: .deviceType)
        status = try? values.decodeIfPresent(Int.self, forKey: .status)
        createdAt = try? values.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
