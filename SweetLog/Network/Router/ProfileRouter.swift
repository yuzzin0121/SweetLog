//
//  ProfileRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case fetchMyProfile
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/v1/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyProfile:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
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
        case .fetchMyProfile:
            return nil
        }
    }
}
