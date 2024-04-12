//
//  APIError.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation

enum APIError: Int, Error, LocalizedError{
    case invalidKey = 420
    case toomanyRequest = 429
    case invalidURL = 444
    case serverError = 500
    
    var errorDescription: String {
        switch self {
        case .invalidKey:
            return "키값이 없거나 틀립니다."
        case .toomanyRequest:
            return "과호출입니다."
        case .invalidURL:
            return "비정상적인 요청입니다."
        case .serverError:
            return "비정상 및 사전에 정의되지 않은 에러가 발생했습니다."
        }
    }
}
