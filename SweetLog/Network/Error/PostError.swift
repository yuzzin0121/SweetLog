//
//  PostError.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

enum fetchPostError: Int, Error, LocalizedError {
    case badRequest = 400
    case cannotBeAuthenticated = 401
    case forbidden = 403
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다"
        case .cannotBeAuthenticated:
            return "인증에 오류가 발생했습니다."
        case .forbidden:
            return "접근할 수 없습니다."
        }
    }
}
