//
//  FilterItem.swift
//  SweetLog
//
//  Created by 조유진 on 4/21/24.
//

import Foundation

enum FilterItem: Int, CaseIterable {
    case total
    case bread
    case cake
    case bakedSnack
    case etc
    
    var title: String {
        switch self {
        case .total: return "전체"
        case .bread: return "빵"
        case .cake: return "케이크"
        case .bakedSnack: return "구움과자"
        case .etc: return "기타"
        }
    }
}
