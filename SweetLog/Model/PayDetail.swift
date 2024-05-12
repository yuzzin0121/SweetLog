//
//  PayDetail.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation

struct PayDetailModel: Decodable {
    let data: [PayDetail]
}

struct PayDetail: Decodable {
    let paymentId: String
    let buyerId: String
    let postId: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantUID = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
