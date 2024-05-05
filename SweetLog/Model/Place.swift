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
    let distance: String
    let id: String
    let phone: String
    let placeName: String
    let placeUrl: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case address = "address_name"
        case categoryName = "category_name"
        case distance
        case id
        case phone
        case placeName = "place_name"
        case placeUrl = "place_url"
        case x
        case y
    }
    
    init(address: String, categoryName: String? = "", distance: String? = "", id: String? = "", phone: String? = "", placeName: String, placeUrl: String, x: String, y: String) {
        self.address = address
        self.categoryName = categoryName ?? ""
        self.distance = distance ?? ""
        self.id = id ?? ""
        self.phone = phone ?? ""
        self.placeName = placeName
        self.placeUrl = placeUrl
        self.x = x
        self.y = y
    }
}

struct PlaceMeta: Decodable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}
