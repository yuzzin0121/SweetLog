//
//  SearchPlaceQuery.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import Foundation

struct SearchPlaceQuery: Encodable {
    let query: String // 검색을 원하는 질의어
    let category_group_code: String?
    let x: String?
    let y: String?
    let radius: Int?
    let rect: String?
    let page: Int
    let size: Int
    let sort: String?
    
    init(query: String,
         category_group_code: String? = nil,
         x: String? = nil, y: String? = nil, radius: Int? = nil,
         rect: String? = nil,
         page: Int = 1, size: Int = 15, sort: String? = nil) {
        self.query = query
        self.category_group_code = category_group_code
        self.x = x
        self.y = y
        self.radius = radius
        self.rect = rect
        self.page = page
        self.size = size
        self.sort = sort
    }
}

// FD6
