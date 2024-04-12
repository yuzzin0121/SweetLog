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
