//
//  ASCountry.swift
//  Dojo
//
//  Created by Ankit Saini on 04/12/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import Foundation
import UIKit

/// Country Modal
struct ASCountry: Codable {
    /// Country Short Code 'US'
    var code: String?
    
    /// Country Name 'United States'
    var name: String?
    
    /// Country Phone Code '+1'
    var phoneCode: String?
    
    /// Country Flag Image url
    //    var flag: String?
    
    /// Country Flag Image
    var flag: UIImage?
    
    //    var flag: UIImage? {
    //        guard let code = self.code else { return nil }
    //        return #imageLiteral(resourceName: code.uppercased())
    //    }
    
    init() {
        self.code = nil
        self.name = nil
        self.phoneCode = nil
        self.flag = nil
    }
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        /// auth_token
        case code = "code"
        /// user
        case name = "name"
        ///
        case phoneCode = "dial_code"
        
        //        case flag = "flag"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        phoneCode = try? values.decodeIfPresent(String.self, forKey: .phoneCode)
        //           flag = try? values.decodeIfPresent(String.self, forKey: .flag)
        flag = UIImage(named: "flag_\(code?.uppercased() ?? "")")
    }
}
