//
//  DataResponseModal.swift
//  SwiftProject
//
//  Created by Mr. X on 08/10/19.
//  Copyright © 2019 Ankit_Saini. All rights reserved.
//

import Foundation
struct DataResponse: Codable {

        let accessToken: String?
        let person: Person?

        enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case person = "person"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
                person = try Person(from: decoder)
        }

}
