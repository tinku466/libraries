//
//  ASResponseModal.swift
//  PickJiCustomer
//
//  Created by Mr. X on 24/09/19.
//  Copyright © 2019 Ankit_Saini. All rights reserved.
//

import Foundation

/// Success Modal of APi Response
struct Success<T: Codable>: Codable {
    let isSuccess: Bool
    let statusCode: Int

    let error: String?
    let errorCode: String?

    let pageNo: Int?
    let pageSize: Int?
    let total: Int?
    
    let data: T?
    
    let items: T?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, error, errorCode, statusCode, data, pageNo, pageSize, total, items
    }
}

/// Response Tuples
struct ResponseTuples {
    let isSuccess: Bool
    let statusCode: Int
    let error: String?
    let errorCode: String?
    let pageNo: Int?
    let pageSize: Int?
    let total: Int?
}
