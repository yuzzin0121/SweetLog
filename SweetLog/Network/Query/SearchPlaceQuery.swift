//
//  SearchPlaceQuery.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import Foundation

struct SearchPlaceQuery: Encodable {
    let query: String // 검색을 원하는 질의어
    let category_group_code: String
    let x: String?
    let y: String?
    let radius: Int?
    let rect: String?
    let page: Int?
    let sort: String?
    
    init(query: String, category_group_code: String = "FD6",
         x: String? = nil, y: String? = nil, radius: Int? = nil,
         rect: String? = nil, page: Int? = nil, sort: String? = nil) {
        self.query = query
        self.category_group_code = category_group_code
        self.x = x
        self.y = y
        self.radius = radius
        self.rect = rect
        self.page = page
        self.sort = sort
    }
}
