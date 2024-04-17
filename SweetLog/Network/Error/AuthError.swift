//
//  AuthError.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation

import Foundation
import Alamofire

enum JoinError: Int, Error, LocalizedError {
    case requiredValue = 400
    case alreadyJoinedUser = 409
    
    var errorDescription: String? {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요."
        case .alreadyJoinedUser:
            return "이미 가입된 유저입니다."
        }
    }
}

enum ValidationEmailError: Int, Error, LocalizedError {
    case requiredValue = 400
    case alreadyJoinedUser = 409
    
    var errorDescription: String? {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요."
        case .alreadyJoinedUser:
            return "사용이 불가한 이메일 입니다."
        }
    }
}

enum LoginError: Int, Error, LocalizedError {
    case requiredValue = 400
    case alreadyJoinedUser = 401
    
    var errorDescription: String? {
        switch self {
        case .requiredValue:
            return "필수값을 채워주세요."
        case .alreadyJoinedUser:
            return "계정을 확인해주세요."
        }
    }
}

enum withdrawError: Int, Error, LocalizedError {
    case cannotBeAuthenticated = 401
    case forbidden = 403

    var errorDescription: String? {
        switch self {
        case .cannotBeAuthenticated:
            return "인증에 오류가 발생했습니다."
        case .forbidden:
            return "접근할 수 없습니다."
        }
    }
}


enum refreshError: Int, Error, LocalizedError {
    case cannotBeAuthenticated = 401
    case forbidden = 403
    case expiredRefreshToken = 418
    
    var errorDescription: String? {
        switch self {
        case .cannotBeAuthenticated:
            return "인증에 오류가 발생했습니다."
        case .forbidden:
            return "접근할 수 없습니다."
        case .expiredRefreshToken:
            return "리프레시 토큰이 만료되었습니다. 다시 로그인 해주세요."
        }
    }
}
