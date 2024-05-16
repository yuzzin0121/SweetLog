//
//  APIError.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation

enum APIError: Int, Error, LocalizedError{
    case cannotSign = 401
    case cannotUse = 409
    case invalidKey = 420
    case toomanyRequest = 429
    case invalidURL = 444
    case serverError = 500
    case refreshTokenExpired = 418
    case accessTokenExpired = 419
    case badRequest = 400
    case forbidden = 403
    case cannotFind
    
    var errorDescription: String? {
        switch self {
        case .cannotSign:
            return "인증할 수 없습니다."
        case .invalidKey:
            return "키값이 없거나 틀립니다."
        case .toomanyRequest:
            return "과호출입니다."
        case .invalidURL:
            return "비정상적인 요청입니다."
        case .serverError:
            return "비정상 및 사전에 정의되지 않은 에러가 발생했습니다."
        case .accessTokenExpired:
            return "액세스 토큰이 만료되었습니다. 토큰을 갱신해주세요."
        case .badRequest:
            return "잘못된 요청입니다"
        case .forbidden:
            return "접근할 수 없습니다."
        case .refreshTokenExpired:
            return "로그인이 필요합니다"
        case .cannotUse:
            return "사용이 불가합니다"
        case .cannotFind:
            return "정보를 찾을 수 없습니다"
        }
    }
}
