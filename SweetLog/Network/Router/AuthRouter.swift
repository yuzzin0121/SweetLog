//
//  Router.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case login(query: LoginQuery)
    case validation(email: ValidationQuery)
    case join(query: JoinQuery)
    case withdraw
    case refresh
}

extension AuthRouter: TargetType {
    
    var baseURL: String {
        return APIKey.payURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .withdraw, .refresh:
            return .get
        case .login, .validation, .join:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        case .validation:
            return "/v1/validation/email"
        case .join:
            return "/v1/users/join"
        case .withdraw:
            return "/v1/users/withdraw"
        case .refresh:
            return "/v1/auth/refresh"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .validation, .join:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .withdraw:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
        case .refresh:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken,
                HTTPHeader.refresh.rawValue: UserDefaultManager.shared.refreshToken
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .login(let query):
            return try? encoder.encode(query)
        case .validation(let email):
            return try? encoder.encode(email)
        case .join(let query):
            return try? encoder.encode(query)
        case .withdraw, .refresh:
            return nil
        }
    }
    
}
