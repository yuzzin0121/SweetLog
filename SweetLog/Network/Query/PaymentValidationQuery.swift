//
//  PaymentValidationQuery.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation

struct PaymentValidationQuery: Encodable {
    let impUID: String
    let postId: String
    let productName: String
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
        case postId = "post_id"
        case productName
        case price
    }
}
