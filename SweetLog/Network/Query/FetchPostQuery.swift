//
//  FetchPostQuery.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

struct FetchPostQuery: Encodable {
    let next: String?
    let limit: String
    let product_id: String?
    let hashTag: String?
    
    init(next: String?, limit: String = "200", product_id: String?, hashTag: String?) {
        self.next = next
        self.limit = limit
        self.product_id = product_id
        self.hashTag = hashTag
    }
}
