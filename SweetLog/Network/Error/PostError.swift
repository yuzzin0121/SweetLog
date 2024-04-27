//
//  PostError.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

enum fetchPostError: Int, Error, LocalizedError {
    case cannotBeAuthenticated = 401
    
    var errorDescription: String? {
        switch self {
        case .cannotBeAuthenticated:
            return "인증에 오류가 발생했습니다."
        }
    }
}


enum LikePostError: Int, Error, LocalizedError {
    case cannotBeAuthenticated = 401
    case canNotFindPost = 410
    
    var errorDescription: String? {
        switch self {
        case .cannotBeAuthenticated:
            return "인증에 오류가 발생했습니다."
        case .canNotFindPost:
            return "게시글을 찾을 수 없습니다"
        }
    }
}

