//
//  PostQuery.swift
//  SweetLog
//
//  Created by 조유진 on 4/24/24.
//

import Foundation

struct PostRequestModel: Encodable {
    let price: String?
    let review: String
    let placeName: String
    let address: String
    let link: String
    let lonlat: String
    let star: String
    let product_id: String
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case price = "title"
        case review = "content"
        case placeName = "content1"
        case address = "content2"
        case link = "content3"
        case lonlat = "content4"
        case star = "content5"
        case product_id = "product_id"
        case files
    }
}
