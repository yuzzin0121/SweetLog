//
//  FetchPostQuery.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

struct FetchPostQuery: Encodable {
    let next: String?
    let limit: String?
    let product_id: String?
}
