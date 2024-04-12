//
//  Router.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query: LoginQuery)
    case validation(email: ValidationQuery)
    case join(query: JoinQuery)
}

extension Router: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
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
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .validation, .join:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
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
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .validation(let email):
            let encoder = JSONEncoder()
            return try? encoder.encode(email)
        case .join(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        }
    }
    
}
