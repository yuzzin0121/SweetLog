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
    case fetchUserProfile(userId: String)
    case editMyProfile
    case follow(userId: String)
    case unfollow(userId: String)
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchMyProfile, .fetchUserProfile:
            return .get
        case .follow:
            return .post
        case .editMyProfile:
            return .put
        case.unfollow:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return "/v1/users/me/profile"
        case .fetchUserProfile(let userId):
            return "/v1/users/\(userId)/profile"
        case .follow(let userId), .unfollow(let userId):
            return "/v1/follow/\(userId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyProfile, .fetchUserProfile, .follow, .unfollow:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
        case .editMyProfile:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
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
        case .fetchMyProfile, .editMyProfile, .fetchUserProfile, .follow, .unfollow:
            return nil
        }
    }
}
