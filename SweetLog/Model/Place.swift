//
//  Place.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import Foundation

struct PlaceModel: Decodable {
    let documents: [PlaceItem]
    let meta: PlaceMeta
}

struct PlaceItem: Decodable {
    let address: String
    let categoryName: String
    let id: String
    let placeName: String
    let placeUrl: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case categoryName = "category_name"
        case id
        case placeName = "place_name"
        case placeUrl = "place_url"
        case x
        case y
    }
}

struct PlaceMeta: Decodable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}
