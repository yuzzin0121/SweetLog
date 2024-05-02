//
//  MoreItem.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import Foundation

enum MoreItem: Int, CaseIterable {
    case edit
    case delete
    
    var title: String {
        switch self {
        case .edit: return "수정"
        case .delete: return "삭제"
        }
    }
}
